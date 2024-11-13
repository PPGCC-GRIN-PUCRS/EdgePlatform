package com.grin.edgeplatform.controllers;

import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;
import io.swagger.v3.oas.annotations.Operation;

import lombok.Data;


@RestController
public class AgentController {

  @Operation(summary = "Get a product by id", description = "Returns a product as per the id")
  @ApiResponses(value = {
    @ApiResponse(responseCode = "200", content = {}),
    @ApiResponse(responseCode = "404", content = {})
  })
  @PostMapping(value = "/notify")
  public ResponseEntity<String> heatBeat(@RequestBody TemperatureBody body) {
    System.out.println(body.temp);
    return ResponseEntity.ok("reached");
  }

  @Operation(summary = "Signup new master cluster server", description = "Returns a product as per the id")
  @ApiResponses(value = {
    @ApiResponse(responseCode = "200", content = {}),
    @ApiResponse(responseCode = "404", content = {})
  })
  @PostMapping("/signup")
  public ResponseEntity<String> signup() {
    return ResponseEntity.ok("reached");
  }

}

@Data
class TemperatureBody {
  String temp;
}
