package com.grin.edgeplatform.entities;

import jakarta.persistence.*;
import lombok.Data;
import org.springframework.data.annotation.LastModifiedBy;
import org.springframework.data.annotation.LastModifiedDate;

import java.time.LocalDateTime;

@Data
@Entity
@Table(name = "Node")
public class Node {

  @Id
  @GeneratedValue(strategy = GenerationType.AUTO)
  private Long id;

  @OneToOne(cascade = CascadeType.ALL)
  @JoinColumn(name = "connections_id", referencedColumnName = "id")
  private Connections connections;

  @Column(nullable = false, updatable = false)
  protected LocalDateTime createdDate;

  @LastModifiedBy
  protected String lastModifiedBy;

  @LastModifiedDate
  protected LocalDateTime lastModifiedDate;

  @Data
  @Entity
  @Table(name = "Connections")
  public static class Connections {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    protected long id;

    @Column(name = "local")
    protected String local;

    @Column(name = "vpn")
    protected boolean vpn;
  }

}
