//
//  Demo.swift
//  ProjectDescriptionHelpers
//
//  Created by 박혜운 on 2023/11/15.
//

import ProjectDescription

private let layerAttribute = Template.Attribute.required("layer")
private let nameAttribute = Template.Attribute.required("name")

private let template = Template(
  description: "A template for a new module's testing target",
  attributes: [
    layerAttribute,
    nameAttribute
  ],
  items: [
    .file(
      path: "Projects/Feature/\(layerAttribute)/Demo/Sources/AppView.swift",
      templatePath: "Testing.stencil"
    )
  ]
)
