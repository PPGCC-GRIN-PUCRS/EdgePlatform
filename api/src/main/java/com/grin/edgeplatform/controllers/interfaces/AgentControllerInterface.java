package com.grin.edgeplatform.controllers.interfaces;

import com.grin.edgeplatform.entities.dtos.NodeDetailsDTO;
import com.grin.edgeplatform.entities.dtos.NodeIngressDTO;
import org.springframework.web.bind.annotation.RestController;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import io.swagger.v3.oas.annotations.Operation;
import org.springframework.http.ResponseEntity;

import com.grin.edgeplatform.entities.dtos.TemperatureBody;

import java.security.NoSuchAlgorithmException;

public interface AgentControllerInterface {

  @Operation(summary = "Get a product by id", description = "Returns a product as per the id")
  @ApiResponses(value = {
    @ApiResponse(responseCode = "200", content = {}),
    @ApiResponse(responseCode = "404", content = {})
  })
  @PostMapping(value = "/notify")
  ResponseEntity<String> heartBeat(@RequestBody NodeIngressDTO body);

  @Operation(summary = "Signup new node server", description = "Ingress new node to the server, giving server self connection informations")
  @ApiResponses(value = {
    @ApiResponse(responseCode = "200", content = {}),
    @ApiResponse(responseCode = "404", content = {})
  })
  @PostMapping("/ingress")
  ResponseEntity<NodeIngressDTO> ingressNode(@RequestBody NodeIngressDTO body) throws Exception;

}
