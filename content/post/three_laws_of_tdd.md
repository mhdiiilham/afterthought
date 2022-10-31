---
title: "Three Laws of Test-Driven Development"
subtitle: ""
date: 2022-10-28T09:49:50+07:00
draft: false
author: "Ilham"
authorLink: "https://twitter.com/w8rloO"
authorEmail: "hi@muhammadilham.xyz"
description: ""
keywords:
- tdd
- test-driven development
- software engineering
- design pattern
- clean code
- uncle bob
- youtube
- go
- Golang
tags:
- tdd
- clean code
- Go
- Golang
categories:
- programming
- tech
- Golang
description: Breaking down the three laws of TDD.
summary: Breaking down the three laws of TDD.
image: https://images.unsplash.com/photo-1516424716439-aeccb78c41c8?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1738&q=80
---
# Introduction
When I studied at Hacktiv8 Indonesia I was told about Test-Driven Development. It is a development process where instead of you write the code real implementation, in TDD you have to write the test first.

I still remember the expression on my face, "lol, we don't have any code? what to test?".

Long story short, I am in love with TDD. Other than it being cool to write a unit test, it also helps a lot in the development process, especially when you working on a team.

If you found that practicing TDD is a pain in the head then you should read this (or at least watch the embedded YouTube Video).

# What Is Test-Driven Development (or TDD)?
Test-Driven Development (or TDD) is a software development process relying on software requirements being converted to test cases before software is fully developed, and tracking all software development by repeatedly testing the software against all test cases.

> Write your test before writing the code they are meant to test.

# The Three Laws of Test-Driven Development
On a fine night while I was "YouTube-ing", I came across this recommended video [The Three Laws of TDD (Featuring Kotlin)](https://www.youtube.com/watch?v=qkblc5WRn-U)

<p align="center">
    <iframe width="560" height="315" src="https://www.youtube.com/embed/qkblc5WRn-U" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"></iframe>
</p>

As someone who's really into programming and know a little about TDD (*and also a big fans of Uncle Bob*), there is no way I going to not watch the video.

Robert C. Martin (“Uncle Bob”) provides a concise set of laws for practicing TDD. Understanding these 3 laws of TDD makes it easier to implement it.

> ### Three Laws of TDD
> 1. Write production code only to pass a failing unit test.
> 2. Write no more of a unit test than sufficient to fail (compilation failures are failures).
> 3. Write no more production code than necessary to pass the one failing unit test.

Let's break down the three laws of TDD while we creating a simple `IsPalindrom(txt string) bool` function in Golang.

```
### Project Structure

learning-tdd/
---- palindrome.go
---- palindrome_test.go
```


## 1. Write Production Code Only To Pass A Failing Unit Test.
This might confuse you (at least I'm so confused). We're only allowed to write production code only to pass a failing unit test, but we just started the project and don't have anything yet.

Then what to code? NONE! You code 0 bytes of code at this point.
<script src="https://gist.github.com/mhdiiilham/7cbc329713a6508062d40634e32e60d4.js"></script>

## 2. Write No More of A Unit Test Than Sufficient To Fail. (Compilation failures are FAILURES!)
Yup, compilation failures are failures. Compilation failures or even a failure warning on your code editor is enough to demonstrate a failure in your code.

Let's start writing the unit test...

<p align="center">
  <img src="https://drive.google.com/uc?export=view&id=1Y5iwim1SwKeX2Zco-SOA2KhUY-OdEXnk" alt="Compilation failures"/>
  <figcaption>0. Compilation Failures</figcaption>
</p>

In the image above, we can see that VSCode gives us a compilation warning (ok, you can run the test if you're having trust issues).
We did it! We just demonstrate a failure. Then we can go on to the third law.

## 3. Write No More Production Code Than Necessary To Pass The One Failing Unit test.
We just created a unit test that fails (compilation failures) now we need to make our code pass the compilation failures.

By adding this code to our `palindrome.go` the compilation failures should be passed now.

```
func IsPalindrome(txt string) bool {
	return false
}
```

If you asking, "wait, why we don't put the implementation right away?". Well, you have to wait.

After this step, we shall go back to the second law of tdd and add a unit test to demonstrate another failure, in this case the failure is when a text is palindrome.

The `palindrome_test.go`:

```go
func TestIsPalindrome(t *testing.T) {
	testCases := []struct {
		name        string
		input       string
		isPalindrom bool
	}{
		{
			name:        "input is palindrome",
			input:       "kodok",
			isPalindrom: true,
		},
	}

	for _, tt := range testCases {
		actual := palindrom.IsPalindrome(tt.input)
		assert.Equal(t, tt.isPalindrom, actual)
	}
}
```

The test will fail and we need to proceed to the third law of TDD again.

<br/><br/>

And that it's. We just switching from the production code to the test code back and forth. You might think this is just a waste of time but it's worth it.

I'm not an expert in Test-Driven Development, but I've been practicing TDD for while now and it helps me and the team. When we want to refactor our project, I almost don't need to ask the code owner about what this and that, but by looking at and understanding the unit test, I am confident enough to refactor it and make sure nothing will break the system as long as the unit tests still passed.

So whether you are a junior, mid, senior, or any level of software engineer I'd recommend you to practice TDD while at work or even if it's just your pet project.

Ok, thankyou!
