package com.grin.edgeplatform.services;

import com.grin.edgeplatform.entities.dtos.NodeIngressDTO;
import com.grin.edgeplatform.repositories.NodeRepository;
import com.grin.edgeplatform.utils.RSAUtils;
import com.grin.edgeplatform.entities.node.Node;
import org.springframework.stereotype.Service;
import org.modelmapper.ModelMapper;
import lombok.AllArgsConstructor;
import java.security.*;

@Service
@AllArgsConstructor
public class NodeService {

  NodeRepository repository;
  ModelMapper mapper;
  RSAUtils rsa;

  public NodeIngressDTO ingress(NodeIngressDTO ingress) throws Exception {
    Node node = mapper.map(ingress, Node.class);
    NodeIngressDTO ingressDetails = null;

    Node existingNodeWithSameConnection = repository.findByConnections_VpnIpv4(ingress.getConnections().getVpnIpv4()).orElse(null);

    if(existingNodeWithSameConnection == null) {
      KeyPair keyPair = rsa.generateKeyPair();
      node.setLastModifiedDate(node.getCreatedDate());
      node.setLastModifiedReason("ingress");
      node.setLastModifiedBy("agent");
      node.setPairingKey(rsa.getPrivateKeyAsString(keyPair.getPrivate()));

      repository.save(node);

      ingressDetails = mapper.map(node, NodeIngressDTO.class);
      ingressDetails.setPairKey(rsa.getPublicKeyAsString(keyPair.getPublic()));
    }

    return ingressDetails;
  }

}
