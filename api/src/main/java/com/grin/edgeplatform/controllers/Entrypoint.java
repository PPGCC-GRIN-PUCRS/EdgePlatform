package com.grin.edgeplatform.controllers;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class Entrypoint {

  @GetMapping("entry")
  public String entrypoint() {
    return "Hello World";
  }

}
