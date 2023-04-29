---
title: "Concurrency With Gomock"
subtitle: ""
date: 2023-04-30T00:55:16+07:00
draft: false
author: "Ilham"
authorLink: "https://twitter.com/w8rloO"
authorEmail: "hi@muhammadilham.xyz"
description: "The article discusses how to test a function that calls a dependency in other goroutines, which can make the test inconsistent. To solve this problem, the author suggests using Go's sync.WaitGroup and GoMock's .Do method. The article provides sample code for testing a service using these methods."
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
summary: The article discusses how to test a function that calls a dependency in other goroutines, which can make the test inconsistent. To solve this problem, the author suggests using Go's sync.WaitGroup and GoMock's .Do method. The article provides sample code for testing a service using these methods.
image:
---

> I promise this gonna be quick one (and also helpful)

<p align="center">
  <img src="https://images.unsplash.com/photo-1670773551763-7f9ef18456b9?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1740&q=80"/>
  Photo by <a href="https://unsplash.com/ko/@nicolewreyford?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Nicole Wreyford</a> on <a href="https://unsplash.com/photos/UeMB9yu92Do?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>
  
</p>

Okay, so still with Go unit testing and mocking. Have you ever encountered when you want to test a function and that function calls a dependency in other goroutines and makes your test inconsistent?

You do? Okay great let's solve it!

Okay, to solve this problem, you gonna need:
1. Go's sync.WaitGroup and
2. GoMock's `.Do` method.

Let's say you have this service

```go
package service

import (
	"context"
	"fmt"
)

type Repository interface {
	DoSomething() error
}

type Service struct {
	repository Repository
}

func NewService(r Repository) *Service {
	return &Service{repository: r}
}

func (s *Service) DoSomething(ctx context.Context) error {
	go func() {
		if err := s.repository.DoSomething(); err != nil {
			fmt.Println("error happening!!!")
		}
	}()
	return nil
}
```

to this this part of the function, you gonna need to do something like this...

```go
package service_test

import (
	"context"
	"example/service"
	"example/service/mock"
	"fmt"
	"sync"
	"testing"

	"github.com/golang/mock/gomock"
	"github.com/stretchr/testify/assert"
)

func TestDoSomething(t *testing.T) {
	t.Run("return nil", func(t *testing.T) {
		ctrl := gomock.NewController(t)
		defer ctrl.Finish()

		var wg sync.WaitGroup
		ctx := context.Background()
		mockRepository := mock.NewMockRepository(ctrl)

		// !!! IMPORTANT NOTE !!!
		// The function (or anonymous function) that you passed
		// into `.Do` method should have exact signature with
		// the method that you called in other goroutines.
		wg.Add(1)
		mockRepository.
			EXPECT().
			DoSomething().
			Times(1).
			Return(nil).
			Do(func() {
				defer wg.Done()
			})

		service := service.NewService(mockRepository)
		actual := service.DoSomething(ctx)

		wg.Wait()
		assert.NoError(t, actual)
	})

	t.Run("return an error", func(t *testing.T) {
		ctrl := gomock.NewController(t)
		defer ctrl.Finish()

		var wg sync.WaitGroup
		ctx := context.Background()
		mockRepository := mock.NewMockRepository(ctrl)

		// !!! IMPORTANT NOTE !!!
		// The function (or anonymous function) that you passed
		// into `.Do` method should have exact signature with
		// the method that you called in other goroutines.
		wg.Add(1)
		mockRepository.
			EXPECT().
			DoSomething().
			Times(1).
			Return(fmt.Errorf("shit happened!")).
			Do(func() interface{} {
				defer wg.Done()
				return fmt.Errorf("shit happened!")
			})

		service := service.NewService(mockRepository)
		actual := service.DoSomething(ctx)

		wg.Wait()
		assert.NoError(t, actual)
	})
}
```

Thank you everyone!


<em>PS: if you want to read more (or understand more) about this, you can go read this good Medium article: [Unit Testing and mock calls inside goroutines by Jeffy Mathew](https://jeffy-mathew.medium.com/unit-testing-and-mock-calls-inside-goroutines-7a19b853e084)<em>
