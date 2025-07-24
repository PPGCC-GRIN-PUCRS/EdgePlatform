package com.grin.edgeplatform.controllers;

import com.grin.edgeplatform.controllers.interfaces.AgentControllerInterface;
import com.grin.edgeplatform.entities.dtos.NodeIngressDTO;
import com.grin.edgeplatform.services.AgentService;
import com.grin.edgeplatform.services.NodeService;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;

import lombok.AllArgsConstructor;

@RestController
@AllArgsConstructor
public class AgentController implements AgentControllerInterface {

  NodeService nodeService;
  AgentService agentService;

  public ResponseEntity<String> install() {
    return ResponseEntity.ok("reached");
  }

  public ResponseEntity<String> content() {
    return ResponseEntity.ok("reached");
  }

  public ResponseEntity<String> heartBeat() {
    return ResponseEntity.ok("reached");
  }

  public ResponseEntity<NodeIngressDTO> heartBeat(@RequestBody NodeIngressDTO body) {
    return ResponseEntity.ok(body);
  }

  public ResponseEntity<NodeIngressDTO> ingressNode(@RequestBody NodeIngressDTO body) throws Exception {
    return new ResponseEntity<>(nodeService.ingress(body), HttpStatus.CREATED);
  }

}
