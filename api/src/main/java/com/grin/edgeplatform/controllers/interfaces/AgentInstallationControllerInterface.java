package com.grin.edgeplatform.controllers.interfaces;

import org.springframework.web.bind.annotation.RequestParam;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.http.ResponseEntity;
import io.swagger.v3.oas.annotations.Operation;
import org.springframework.http.MediaType;

public interface AgentInstallationControllerInterface {

    @Operation(summary = "Agent install script", description = "Given the agent linux install bash script over cached availability")
    @ApiResponse(responseCode = "200", content = {})
    @ApiResponse(responseCode = "404", content = {})
    @GetMapping(value = "/install.sh", produces = MediaType.TEXT_PLAIN_VALUE)
    ResponseEntity<String> install(
            @RequestParam(required = false, defaultValue = "false") boolean refresh);

    @GetMapping(value = "/content")
    ResponseEntity<String> content();// @RequestBody NodeIngressDTO body);

}
