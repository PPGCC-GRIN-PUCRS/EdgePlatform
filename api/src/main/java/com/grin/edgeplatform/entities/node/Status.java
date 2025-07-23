package com.grin.edgeplatform.entities.node;

import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@Entity
@Table(name = "NODE_STATUS")
public class Status {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  @Column(nullable = false, updatable = false)
  private String cpuTemperature;

  @ManyToOne(fetch = FetchType.LAZY)
  @JoinColumn(name = "node_id", nullable = false, updatable = false)
  private Node node;

  @Column(nullable = false, updatable = false)
  protected LocalDateTime createdDate;

}
