---
title: "Mock Me, Please!!!"
subtitle: "Golang GoMock Guide"
date: 2023-02-23T01:17:43+07:00
draft: false
author: "Ilham"
authorLink: "https://twitter.com/w8rloO"
authorEmail: "hi@muhammadilham.xyz"
description: ""
keywords:
- Go
- Golang
- Mock
- Mocking
- Test
- Unit Test
tags:
- Go
- Golang
- tdd
- Testing
categories:
- Go
- Testing Technique
summary: "This article explains how to use GoMock, a mocking framework for the Go programming language, to mock external dependencies in order to facilitate unit testing. The article provides step-by-step instructions for generating a mock instance of an interface using GoMock, as well as an example test function that uses the mock to test the behavior of a service layer."
image:
---

<p align="center">
  <img src="https://images.unsplash.com/photo-1670773551763-7f9ef18456b9?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1740&q=80"/>
  Photo by <a href="https://unsplash.com/ko/@nicolewreyford?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Nicole Wreyford</a> on <a href="https://unsplash.com/photos/UeMB9yu92Do?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>
  
</p>

Back in my early day as a software engineer, I used to have two development databases, one for development (yeah, obviously) and another one for unit testing. I never knew what is mocking, and how to use it, and yet I never mock any piece of my code for unit testing purposes simply because I don't understand the idea of a unit test.

In this jot, I want to talk about how to use GoMock, a tool by Go, to mock your external dependencies.

## What is `GoMock`?

> gomock is a mocking framework for the Go programming language. It integrates well with Go's built-in testing package, but can be used in other contexts too. - [golang/mock](https://github.com/golang/mock#gomock)

To install `GoMock`, you can use `go install`'s command:

```shell
go install github.com/golang/mock/mockgen@v1.6.0
```

Once you installed GoMock, you can use the GoMock's CLI using command `mockgen` on your terminal.

<p align="center">
  <img src="https://i.ibb.co/wWCWdKj/mockgen.jpg" alt="mockgen command"/>
</p>

## Let's Start Mocking!

Let's say you have a service layer. Your service layer has a dependency on the repository layer that include DB connection.

```txt
project
│   README.md
└───service
│   │   library.go
```

Since the purpose of a unit test is to test your unit of code (function, method, etc...), you don't need the actual implementation of the repository layer, you only want to make sure that the behavior of the code that you wrote is working as you expect, here's come the mocking part.

```go
package service

import (
	"context"

	"github.com/mhdiiilham/go-101/model"
)

type BookRepository interface {
	GetBooks(ctx context.Context) (book []model.Book, err error)
}

type LibraryService struct {
	repository BookRepository
}

func NewLibraryService(repository BookRepository) *LibraryService {
	return &LibraryService{repository: repository}
}

func (s *LibraryService) GetBooks(ctx context.Context) (books []model.Book, err error) {
	books, err = s.repository.GetBooks(ctx)
	if err != nil {
		return nil, err
	}

	return books, nil
}
```

To test `GetBooks` method, first, we need to generate the mock instance of BookRepository.

There's two way on how to generate the mock.

### How To Create The Mock

#### 1. Reflect mode

Reflect mode generates mock interfaces by building a program that uses reflection to understand interfaces. It is enabled by passing two non-flag arguments: an import path, and a comma-separated list of symbols.

You can use "." to refer to the current path's package.

To create the mock using `go:generate` command, you need to add `go:generate` on top of your interface.

```go
//go:generate mockgen -destination=mock/mock_repository.go -package=mock . BookRepository
type BookRepository interface {
	GetBooks(ctx context.Context) (book []model.Book, err error)
}
```

then run command

```zsh
go generate ./...
```

##### Error

You might (or might not) get an error like this

```zsh
$ go generate ./...
prog.go:12:2: no required module provides package github.com/golang/mock/mockgen/model; to add it:
        go get github.com/golang/mock/mockgen/model
prog.go:12:2: no required module provides package github.com/golang/mock/mockgen/model; to add it:
        go get github.com/golang/mock/mockgen/model
prog.go:12:2: no required module provides package github.com/golang/mock/mockgen/model: go.mod file not found in current directory or any parent directory; see 'go help modules'
prog.go:14:2: no required module provides package github.com/mhdiiilham/go-101/service: go.mod file not found in current directory or any parent directory; see 'go help modules'
2023/02/25 13:46:24 Loading input failed: exit status 1
service/library.go:3: running "mockgen": exit status 1
```

To solve this error, just run the go get command:

```zsh
go get github.com/golang/mock/mockgen/model
```

#### 2. Source mode

Source mode generates mock interfaces from a source file. It is enabled by using the -source flag.

example

```zsh
mockgen -source=service/library.go -destination=service/mock/mock_book_repository.go -package=mock
```

These two will create new direcory under your `service/` with generate file that contained your mock instance of `BookRepository`.

```txt
project
│   README.md
└───service
│   │   library.go
│   └───mock
│       │   mock_repository.go
```

## The Func Part! 😺

Let's start testing our function...

```go
package service_test

import (
	"context"
	"testing"

	"github.com/golang/mock/gomock"
	"github.com/mhdiiilham/go-101/model"
	"github.com/mhdiiilham/go-101/service"
	"github.com/mhdiiilham/go-101/service/mock"
	"github.com/stretchr/testify/assert"
)

func TestLibraryServiceGetBooks(t *testing.T) {
	ctx := context.Background()
	assertion := assert.New(t)

	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	expectedBooks := []model.Book{
		{Title: "Inferno", Author: "Dan Brown"},
		{Title: "The Subtle Art Of Not Giving A F#", Author: "Mark Mason"},
	}

	mockRepository := mock.NewMockBookRepository(ctrl)

	service := service.NewLibraryService(mockRepository)

	books, err := service.GetBooks(ctx)
	assertion.NoError(err)
	assertion.Equal(expectedBooks, books)
}
```

#### <em>Explantion</em>:
- `ctrl`: A Controller represents the top-level control of a mock ecosystem.
- `mockRepository`: The mock instance that you going to use as the replacement of the actual repository.

If you run the test, It'll fail because we haven't use the mock instance, yet.

We need to customize the behavior of the mock repository, what argument is passed into the function, what are the returns, and how many times it is called. To do that, check this code snippet...

```go
mockRepository := mock.NewMockBookRepository(ctrl)

mockRepository.
		EXPECT().
		GetBooks(ctx).
		Return(expectedBooks, nil).
		Times(1)
```

On the mock instance, we **EXPECT** that we call the **GetBooks** method with argument `ctx` and the method should **Return** `expectedBooks` and `nil` (we don't expect any error).

Other example if we want to test how our function handle the error:

```go
mockRepository.
		EXPECT().
		GetBooks(ctx).
		Return(nil, sql.ErrNoRows).
		Times(1)
```

## Conclusion

In conclusion, GoMock is a powerful mocking framework for the Go programming language that enables developers to mock external dependencies, and unit test their code without relying on the actual implementation of the dependencies. With GoMock, developers can create mock instances of their dependencies and test the behavior of their code as expected.
