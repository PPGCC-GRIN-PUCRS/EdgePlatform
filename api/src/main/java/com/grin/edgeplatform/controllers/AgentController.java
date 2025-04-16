package com.grin.edgeplatform.controllers;

import com.grin.edgeplatform.controllers.interfaces.AgentControllerInterface;
import com.grin.edgeplatform.entities.dtos.NodeDetailsDTO;
import com.grin.edgeplatform.entities.dtos.NodeIngressDTO;
import com.grin.edgeplatform.entities.dtos.TemperatureBody;
import com.grin.edgeplatform.services.NodeService;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;

import java.security.NoSuchAlgorithmException;


@RestController
@AllArgsConstructor
public class AgentController implements AgentControllerInterface {

  NodeService nodeService;

  public ResponseEntity<String> heartBeat(@RequestBody NodeIngressDTO body) {
    return ResponseEntity.ok("reached");
  }


  public ResponseEntity<NodeIngressDTO> ingressNode(@RequestBody NodeIngressDTO body) throws Exception {
    return new ResponseEntity<>(nodeService.ingress(body), HttpStatus.CREATED);
  }

}
