package com.grin.edgeplatform.entities.bo.headscale;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.proxy.HibernateProxy;

import java.time.ZonedDateTime;
import java.util.List;
import java.util.Objects;

@Getter
@Setter
@ToString
@RequiredArgsConstructor
@Entity
@Table(name = "HEADSCALE_MACHINES")
public class HeadscaleMachine {

  @Id
  private String id;

  private String machineKey;
  private String nodeKey;
  private String discoKey;

  @ElementCollection
  @CollectionTable(name = "node_ip_addresses", joinColumns = @JoinColumn(name = "node_id"))
  @Column(name = "ip_address")
  private List<String> ipAddresses;

  private String name;

  @ManyToOne(cascade = CascadeType.ALL)
  @JoinColumn(name = "user_id")
  private HeadscaleUser user;

  private ZonedDateTime lastSeen;
  private ZonedDateTime lastSuccessfulUpdate;
  private ZonedDateTime expiry;
  private ZonedDateTime createdAt;

  private String registerMethod;
  private String givenName;
  private boolean online;

  // Arrays of tags
  @ElementCollection
  @CollectionTable(name = "node_forced_tags", joinColumns = @JoinColumn(name = "node_id"))
  @Column(name = "tag")
  private List<String> forcedTags;

  @ElementCollection
  @CollectionTable(name = "node_invalid_tags", joinColumns = @JoinColumn(name = "node_id"))
  @Column(name = "tag")
  private List<String> invalidTags;

  @ElementCollection
  @CollectionTable(name = "node_valid_tags", joinColumns = @JoinColumn(name = "node_id"))
  @Column(name = "tag")
  private List<String> validTags;

  @Override
  public final boolean equals(Object o) {
    if (this == o) return true;
    if (o == null) return false;
    Class<?> oEffectiveClass = o instanceof HibernateProxy ? ((HibernateProxy) o).getHibernateLazyInitializer().getPersistentClass() : o.getClass();
    Class<?> thisEffectiveClass = this instanceof HibernateProxy ? ((HibernateProxy) this).getHibernateLazyInitializer().getPersistentClass() : this.getClass();
    if (thisEffectiveClass != oEffectiveClass) return false;
    HeadscaleMachine machine = (HeadscaleMachine) o;
    return getId() != null && Objects.equals(getId(), machine.getId());
  }

  @Override
  public final int hashCode() {
    return this instanceof HibernateProxy ? ((HibernateProxy) this).getHibernateLazyInitializer().getPersistentClass().hashCode() : getClass().hashCode();
  }
}
