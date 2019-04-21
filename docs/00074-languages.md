# USDT examples in other dynamic languages

To demonstrate the portability of these same concepts, language-specific examples are provided here.

We will implement the same `hello-word` style of probe of each of them, and explain the differences and implementation of each language.

## Ruby wrapper (featured elsewhere)

Above `ruby-static-tracing`[@ruby-static-tracing] is featured more and examined heavily featured than other language runtimes, to illustrate the approach of adding `libstapsdt` to a dynamic runtime. Most of these same concepts apply to other languages. For example, the Rails usage concept of tracers may be portable to Django. In the same way that `ruby-static-tracing` offers an abstraction above tracepoints, other runtimes could take similar approaches.

Ruby won't be repeated here, and it is the author's [@dalehamel] bias and ignorance that Ruby is featured more heavily throughout the rest of the report.

If you have examples of more detailed uses of each of USDT tracepoints in any other languages missing here, please submit a pull request.

## Python wrapper

To illustrate the point, we'll how we're able to add static tracepoints to python, which is similar to what we'll be doing here with ruby.

Examining the [python wrapper](https://github.com/sthima/python-stapsdt) [@mmarchini], we can see a sample probe program:


```{.python include=src/python-stapsdt/README.md startLine=36 endLine=50}
```

[see pypi to install](https://pypi.org/project/stapsdt/)

## NodeJS wrapper

A similar example, in [nodejs](https://github.com/sthima/node-usdt.git) [@mmarchini], a similar sample probe:

```{.javascript include=src/node-usdt/README.md startLine=37 endLine=57}
```

[see npm to install](https://www.npmjs.com/package/usdt)

## golang wrapper

For golang, our example comes from [salp](https://github.com/mmcshane/salp) [@mmcshane]:

```{.go include=src/salp/internal/salpdemo.go startLine=12 endLine=17}
```
