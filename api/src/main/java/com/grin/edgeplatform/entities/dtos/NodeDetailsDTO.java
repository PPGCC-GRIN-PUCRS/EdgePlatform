package com.grin.edgeplatform.entities.dtos;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class NodeDetailsDTO {

  private Long id;
  private com.grin.edgeplatform.entities.node.Node.Connections connections;
  private LocalDateTime createdDate;
  private String lastModifiedBy;
  private String lastModifiedReason;
  private LocalDateTime lastModifiedDate;

}
