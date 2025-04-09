package com.grin.edgeplatform.controllers;

import com.grin.edgeplatform.controllers.interfaces.AgentControllerInterface;
import com.grin.edgeplatform.entities.dtos.TemperatureBody;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;


@RestController
public class AgentController implements AgentControllerInterface {

  public ResponseEntity<String> heartBeat(@RequestBody TemperatureBody body) {
    System.out.println(body);
    return ResponseEntity.ok("reached");
  }


  public ResponseEntity<String> ingressNode() {
    return ResponseEntity.ok("reached");
  }

}
