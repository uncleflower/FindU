# FindU

> FindU is a command-line tool for calculating class usage in your Xcode project.

When counting how many times a class is used in the project, you may use global file search, but it is easy to get many similar class which have similar class name but is not the target Class. And when counting Swift class we may not want to search in Objective-C code, similarly for Objective-C class we don't want to search in Swift code

## Install

- Download project from Github
- Compile project get executable file 

```bash
> git clone https://github.com/uncleflower/FindU.git
> cd FindU
> swift build -c release
```

## Usage

Input your project path and target class name run following command, you will get the number of times the class has been used in your project.

```shell
> .build/release/FindU -p path/to/project -c TargetClassName
```

You can use following command to specify whether it is a Swift class or an Objective-C class, Swift class will only searched in .swift file, Objective-C class will searched in .h, .m., .mm file

```shell
> .build/release/FindU -p path/to/project -c ClassName1 ClassName2 -s SwiftClassName1 SwiftClassName2 -o OCClassName1 OCClassName2
```

FindU support customize the print format by using --print-format argument

```shell

> .build/release/FindU -p path/to/project -c ClassName1 ClassName2 -s SwiftClassName1 SwiftClassName2 -o OCClassName1 OCClassName2 --print-format "Class:<C> Total:<T> Paths:<P>"

```

## License and Information

FindU is under the MIT license. 

Submit [an issue](https://github.com/uncleflower/FindU/issues/new) if you find something wrong. Pull requests are warmly welcome.
