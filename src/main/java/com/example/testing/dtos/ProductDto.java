package com.example.testing.dtos;

import lombok.Value;

import java.io.Serializable;



@Value
public class ProductDto implements Serializable {
    String name;
    Double price;
}