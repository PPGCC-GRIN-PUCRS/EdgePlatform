package com.grin.edgeplatform.controllers.interfaces;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.http.ResponseEntity;

import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;

import com.grin.edgeplatform.entities.dtos.NodeIngressDTO;

@RequestMapping(path = "/agent")
@Tag(name = "Agent Management Entrypoint", description = "Every requirement and access point aiming agent connections")
public interface AgentControllerInterface extends AgentInstallationControllerInterface {

  @Operation(summary = "Notify agent status to the platform", description = "Returns an ACK from the server and any possible task that should be taken by the agent")

  @ApiResponse(responseCode = "200", description = "Successfully retrieved employee", content = @Content(mediaType = "application/json", schema = @Schema(implementation = String.class)))
  @ApiResponse(responseCode = "404", description = "Agent not registered")
  @PostMapping(value = "/notify")
  ResponseEntity<NodeIngressDTO> heartBeat(@RequestBody NodeIngressDTO body);

  @GetMapping(value = "/anonymous/notify")
  ResponseEntity<String> heartBeat();// @RequestBody NodeIngressDTO body);

  @Operation(summary = "Signup new node server", description = "Ingress new node to the server, giving server self connection informations")
  @ApiResponse(responseCode = "200", content = {})
  @ApiResponse(responseCode = "404", content = {})
  @PostMapping("/ingress")
  ResponseEntity<NodeIngressDTO> ingressNode(@RequestBody NodeIngressDTO body) throws Exception;

}
