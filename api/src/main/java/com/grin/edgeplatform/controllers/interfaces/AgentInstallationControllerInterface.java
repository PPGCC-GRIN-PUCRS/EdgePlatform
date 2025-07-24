package com.grin.edgeplatform.controllers.interfaces;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.http.ResponseEntity;

import io.swagger.v3.oas.annotations.tags.Tag;

@Tag(name = "Agent Install Entrypoint", description = "Every requirement to install agent")
public interface AgentInstallationControllerInterface {

    @GetMapping(value = "/install.sh")
    ResponseEntity<String> install();// @RequestBody NodeIngressDTO body);

    @GetMapping(value = "/content")
    ResponseEntity<String> content();// @RequestBody NodeIngressDTO body);

}