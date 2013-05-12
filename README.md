ask_me
======

this tool should help during preparation for a exam, it ask you questions and gives you the answer

how to use it
=============

generate a questions file in the following syntax:

```
q: question
a: answer single line
```

or
```
a: {{ first line
second line}}
```
you can also add images to questions which are opened during the question is asked by the folowing syntax
```
q: question
i: path to image
a: answer like above described
```
it is also possible to add images in the answer
```
q: question
a: i: path to image
```
or
```
q: question
a: {{answertext
line 2
i: path to image}}
```

how to run it
=============
* clone the sources
* run the application

```
ruby src/ask_me.rb questions.conf
```
