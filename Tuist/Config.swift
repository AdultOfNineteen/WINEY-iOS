import ProjectDescription

//let config = Config(
//    plugins: [
//        .local(path: .relativeToManifest("../../Plugins/Winey")),
//    ]
//)

let config = Config(
  plugins: [
    .local(path: .relativeToRoot("Plugins/ConfigPlugin")),
    .local(path: .relativeToRoot("Plugins/EnvPlugin"))
  ]
)
