package com.grin.edgeplatform.entities.dtos;

import java.time.LocalDateTime;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
public class NodeIngressDTO {
  @Schema(description = "Unique identifier of the agent", example = "123")
  private Long id;
  private com.grin.edgeplatform.entities.node.Node.Connections connections;
  private String PairKey;
  private LocalDateTime createdDate;
  private String lastModifiedBy;
  private String lastModifiedReason;
  private LocalDateTime lastModifiedDate;

}
