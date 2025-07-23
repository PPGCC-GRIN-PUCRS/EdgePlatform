package com.grin.edgeplatform.entities.dtos;

import com.grin.edgeplatform.entities.node.Node;
import com.grin.edgeplatform.entities.node.Status;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.OneToMany;
import lombok.Data;
import org.springframework.data.annotation.LastModifiedBy;
import org.springframework.data.annotation.LastModifiedDate;

import java.security.PublicKey;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class NodeIngressDTO {

  private Long id;
  private com.grin.edgeplatform.entities.node.Node.Connections connections;
  private String PairKey;
  private LocalDateTime createdDate;
  private String lastModifiedBy;
  private String lastModifiedReason;
  private LocalDateTime lastModifiedDate;

}
