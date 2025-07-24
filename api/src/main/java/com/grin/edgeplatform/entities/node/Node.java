package com.grin.edgeplatform.entities.node;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.proxy.HibernateProxy;
import org.springframework.data.annotation.LastModifiedBy;
import org.springframework.data.annotation.LastModifiedDate;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Objects;

@Data
@Entity
@Table(name = "NODE")
public class Node {

  @Id
  @GeneratedValue(strategy = GenerationType.AUTO)
  private Long id;

  @OneToOne(cascade = CascadeType.ALL)
  @JoinColumn(name = "connections_id", referencedColumnName = "id")
  private Connections connections;

  @Column(columnDefinition = "TEXT")
  private String pairingKey;

  @OneToMany(mappedBy = "node", cascade = CascadeType.ALL, orphanRemoval = true)
  @ToString.Exclude
  private List<Status> status;

  @CreationTimestamp
  @Column(updatable = false)
  protected LocalDateTime createdDate;

  @LastModifiedDate
  @CreationTimestamp
  private LocalDateTime lastModifiedDate;

  @LastModifiedBy
  private String lastModifiedBy;

  @LastModifiedBy
  private String lastModifiedReason;

  @Data
  @Entity
  @Table(name = "Connections")
  public static class Connections {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;

    @Column(name = "username")
    private String username;

    @Column(name = "hostname")
    private String hostname;

    @Column(name = "local")
    private String local;

    @Column(name = "vpnIpv4")
    private String vpnIpv4;

    @Column(name = "vpnIpv6")
    private String vpnIpv6;
  }

  @Override
  public final boolean equals(Object o) {
    if (this == o)
      return true;
    if (o == null)
      return false;
    Class<?> oEffectiveClass = o instanceof HibernateProxy
        ? ((HibernateProxy) o).getHibernateLazyInitializer().getPersistentClass()
        : o.getClass();
    Class<?> thisEffectiveClass = this instanceof HibernateProxy
        ? ((HibernateProxy) this).getHibernateLazyInitializer().getPersistentClass()
        : this.getClass();
    if (thisEffectiveClass != oEffectiveClass)
      return false;
    Node node = (Node) o;
    return getId() != null && Objects.equals(getId(), node.getId());
  }

  @Override
  public final int hashCode() {
    return this instanceof HibernateProxy
        ? ((HibernateProxy) this).getHibernateLazyInitializer().getPersistentClass().hashCode()
        : getClass().hashCode();
  }
}
