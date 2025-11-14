package com.example.testing.dtos;

import lombok.Value;

import java.io.Serializable;


@Value
public class CustomerDto implements Serializable {
    String name;
    String email;
}