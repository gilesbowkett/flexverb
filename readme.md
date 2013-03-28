# Flexverb

TLDR: Flexverb is a weird toy programming language based on Latin and
Ancient Greek. It is essentially a blog post, in executable code form,
about an obscure linguistic quirk and its unexpected benefits.

## Word order and transformation in classical Western languages

When I was in high school, I really enjoyed classical languages. I got
nostalgic about that recently. And this prompted an idea.

Classical languages communicate a word's grammatical purpose not through
the word's location in the sentence, but through its form. If you want
to say "farmer," in Latin, you can't, at least, not yet. There isn't
enough information to determine the shape of the word, because the shape
of the word will depend on how you use it. You have to also choose its
use case.

The Latin word for "farmer" will be "agricola" if there is one farmer who
is the subject of the sentence. But if the farmer plays the role of the
direct object in the sentence, the word will be "agricolam." In other
words, the agricola says hello, but you say hello to the agricolam.

I'll oversimplify for the purposes of this readme, and you can find
corrections below, but in English, "the farmer said hello" only works
as a sentence if "the farmer" appears at the beginning. "Said hello the
farmer" doesn't mean anything. Even Yoda would have to say "Said hello,
the farmer did" for people to make sense of that. But in Latin, you
could put "agricola" at the beginning of the sentence, at the end, or in
the middle. Since the word's form communicates its purpose, its location
is irrelevant. So "says hello agricola" means "the farmer says hello,"
and "agricola says hello" also means "the farmer says hello."

But even though "agricola says hello" and "says hello agricola" do not
differ insofar as each communicates the same basic idea, they do differ
as sentences. Latin and Greek used these differences to communicate
nuance and emphasis. "Agricola says hello" emphasizes that the farmer
said *hello*, as opposed to goodbye. "Says hello agricola" emphasizes
that it was the *farmer* who said it. Since word order didn't play
the central role in Latin or Greek grammar which it plays in English
grammar, writers were free to use it for more subtle purposes. This is a
freedom which code could, at least in theory, benefit from.

Flexverb is a toy language, implemented in Ruby via Parselet, in which
token order is inconsequential.

For example:

    verb(print) direct-object("hello world")

The verb is `print`, the object is `"hello world"`. You can abbreviate
those terms:

    v(print) o("hello world")

More importantly, you can switch them around:

    o("hello world") v(print)

So if you print "hello world", and then you print something else, use
the first form.

    v(print) o("hello world")
    v(print) o("I like turtles")

But use the second form if you first print "hello world," and next you
say it out loud through a speech synthesizer (like the `say` command in
OS X).

    o("hello world") v(print)
    o("hello world") v(say)

Obviously, this is a silly example, but consider a controller in a web
app, which, after a user signs up, needs to email a confirmation message
and also add welcome text to the next page it renders.

    verb(render) adjective(welcome) object(message)
    verb(email) adjective(confirmation) object(message)

Which of course compresses to

    v(render) a(welcome) o(message)
    v(email) a(confirmation) o(message)

Add syntax highlighting and permissive whitespace:

    v(render)   a(welcome)        o(message)
    v(email)    a(confirmation)   o(message)

(screenshot)

It's really easy to see how the above code sample could turn into a
pair of `message` objects which have different content, and which each
implement their `send` function slightly differently.

Likewise, it's really easy to see how the following Flexverb code could
get shorter with a `with` statement like those found in [JavaScript](https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Statements/with)
and [Python](http://docs.python.org/release/2.5/whatsnew/pep-343.html):

    o("hello world")   v(print)
    o("hello world")   v(email)
    o("hello world")   v(render)
    o("hello world")   v(say)

(syntax-coloring screenshot)

Although Flexverb has plenty of silly failings, it has one really
wonderful advantage: it suggests refactorings very rapidly. It's really
easy to look at Flexverb code and see ways to structure it. In my
opinion, this echoes one of the virtues of human classical languages.

Lawyers often learn classical languages prior to entering law school,
not just because Western legal systems contain a lot of terminology
dating back to the Roman Empire, but also because classical languages
train you to structure your thoughts. For this latter reason, I also
recommend studying classical languages for any programmer.

In Latin and Ancient Greek, the freedom to structure sentences any way
you like, coupled with very explicit grammar, makes it really easy to
surface implicit lists, grids, and hierarchies. I believe this simple,
toy example of a programming language makes those same things easy by
having those same characteristics.

## Syntax Highlighting

In a language like this, syntax highlighting is crucial. See the
`highlighters` dir for syntax highlighting files for both TextMate and
Vim.

Syntax highlighting for Flexverb greys out the `v()` stuff but
color-codes the parts of speech distinctly.

## Epic humblebrag

This is actually how I first discovered syntax highlighting. I invented
it independently long before I ever saw it in a text editor, back when
I was studying Latin for fun after dropping out of college. I realize
that every part of that last sentence is insane, but it's all true.

I was taking a class through a local university's extension
program. We were reading [a book in Latin by the philosopher
Cicero](http://en.wikipedia.org/wiki/Laelius_de_Amicitia). All the
different "agricola" and "agricolam" permutations were hard to remember,
but easy to look up and label, so I'd first underline each word in a
sentence with a particular color to indicate the word's grammatical
function, and then read the whole sentence through.

## Math

I haven't implemented this, but here's how I imagine it working.

    s(23) v(times) o(5)

corresponds to

    23 * 5

which is how Ruby models basic math, because `*` is really just a method
on the object `23`. This equivalent Ruby makes the underlying semantics
more explicit:

    23.* 5

Meanwhile,

    v(multiply) s(23) o(5)

retains those exact same semantics, but phrases it in the way Lisps
phrase basic math. (Flexverb should probably give you both `times` and
`multiply` for convenience.) To translate:

    (* 23 5)

Flexverb should permit either phrasing.

## Operator precedence

[Loren Segal provided a simple math challenge](https://twitter.com/lsegal/status/312778714737934336):

    5 + 3 * 12

That's easy!

    s(5) v(plus) o(s(3) v(times) o(12))

(syntax highlighting pic)

You can just as easily express that as

    v(add) o(o(12) s(3) v(multiply)) s(5)

It looks weird, but it works. I believe a similar nesting is the
standard Lisp response to operator precedence, and indeed with syntax
highlighting this looks like a verbose Lisp.

(pic)

Consider the Lisp equivalent:

    (+ (* 12 3) 5)

## Not for production use, duh

Obviously this is an exploratory project. I don't expect the language to
see a whole lot of adoption, and it's a very incomplete implementation.
It's really just a fun toy for people who find languages interesting.

## A note about the actual human languages

Everything I said above oversimplifies Latin. To use actual Latin
vocabulary, the sentences "agricola says hello" and "says hello
agricola" would be something more like "agricola dicit vale" and
"dicit vale agricola," but I think "agricola vale dicit" and "vale
dicit agricola" would actually be more idiomatic. Word order is not
entirely inconsequential in classical languages, it's just much, much
less significant and rigid than it is in English. Also, rather than two
forms, "farmer" in Latin takes at least 10 different forms, and that's
just for beginner-level stuff like "the field was plowed by the farmers"
and "this is the farmer's farm."

Ancient Greek is even more complicated. I think some words can take a
total of 17 different forms, maybe even more. Also, the Romans made
Latin a standardized language everywhere in their empire, while the
independent Greek city-states each developed their own different,
idiosyncratic dialect. So that's not really 17 forms per word; it's 17
forms per word, per dialect.

## Todo

* Implement all specs
* Implement say as say
* Implement print as print

## Related projects

http://www.csse.monash.edu.au/~damian/papers/HTML/Perligata.html

