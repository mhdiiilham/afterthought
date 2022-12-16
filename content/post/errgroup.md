---
title: "The errgroup package: Your secret weapon for managing concurrent goroutines in Go"
subtitle: ""
date: 2022-12-16T11:30:00+07:00
draft: false
author: "Ilham"
authorLink: "https://twitter.com/w8rloO"
authorEmail: "hi@muhammadilham.xyz"
description: "The errgroup package is a Go library that makes it easy to run a bunch of tasks concurrently and then cry in despair if any of them fail. So don't let concurrent tasks ruin your day anymore, give the errgroup package a try and enjoy the peace of mind that comes with knowing that your tasks are being managed and your errors are being caught."
keywords:
tags:
categories:
summary: "The errgroup package is a Go library that makes it easy to run a bunch of tasks concurrently and then cry in despair if any of them fail. So don't let concurrent tasks ruin your day anymore, give the errgroup package a try and enjoy the peace of mind that comes with knowing that your tasks are being managed and your errors are being caught."
image: https://images.unsplash.com/photo-1525785967371-87ba44b3e6cf?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1473&q=80
---
Are you tired of managing the concurrent execution of multiple goroutines in Go, only to have them fail and ruin your entire day? Well, fear not dear reader, because the `errgroup` package is here to save the day!

This small, open-source library provides a simple and convenient way to run a group of independent tasks concurrently, and then wait for all of them to complete (or for one of them to fail and ruin everything). All you have to do is create a new `errgroup.Group` object and pass it to the functions that you want to run concurrently. Each of these functions should return an error value, which will be captured by the `errgroup.Group` object like a little error-catching ninja.

Here's an example of how to use the errgroup package to concurrently fetch the contents of multiple URLs and then cry in despair if any of them fail:

```go
package main

import (
	"context"
	"fmt"
	"io/ioutil"
	"net/http"
	"time"

	"golang.org/x/sync/errgroup"
)

func main() {
	urls := []string{
		"https://www.example.com/",
		"https://www.example.net/",
		"https://www.example.org/",
	}

	ctx, cancel := context.WithTimeout(context.Background(), time.Second*10)
	defer cancel()

	g, ctx := errgroup.WithContext(ctx)

	for _, url := range urls {
		url := url // capture range variable
		g.Go(func() error {
			resp, err := http.Get(url)
			if err != nil {
				return err
			}
			defer resp.Body.Close()

			_, err = ioutil.ReadAll(resp.Body)
			return err
		})
	}

	if err := g.Wait(); err != nil {
		fmt.Println("Oh no, something went wrong :(")
		fmt.Println(err)
	}
}

```

As you can see, using the `errgroup` package is as easy as pie (or perhaps even easier, depending on your pie-making skills). And the best part is, if any of the goroutines fail, the `Wait()` method will return that error and you can go cry in a corner (or at least, that's what I do).

So don't let concurrent goroutines ruin your day anymore, give the `errgroup` package a try and enjoy the peace of mind that comes with knowing that your tasks are being managed and your errors are being caught. Happy coding!
