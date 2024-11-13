package com.grin.edgeplatform.entities;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.Data;

@Data
@Entity
public class Node {

  @Id
  private Long id;

}
