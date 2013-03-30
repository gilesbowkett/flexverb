# FlexVerb: A Serious Toy Language

TLDR: FlexVerb is a barely-implemented programming language based on
Latin and Ancient Greek. It is essentially a blog post, in executable
code form, about an obscure linguistic quirk and its unexpected
benefits.

## Implementation

There is hardly any implementation at all. I've only implemented the
smallest possible subset of FlexVerb. (I will happily add contributors
to the GitHub repo if I see sensible pull requests, though.) I
implemented only a tiny subset partly because this is the first language
I've ever implemented in the first place, and mostly because I only need
a tiny subset working in order to make my point.

Here is pretty much everything you can actually do, in real life, with
FlexVerb today:

    ↪  bin/flexverb -e 'verb(print) direct-object("hello world")'
    hello world

    ↪  bin/flexverb hello_world.fv
    hello world

That's pretty much it. That and a syntax definition file for Vim.

## Why FlexVerb is interesting anyway

Most programming languages are based either on the language of modern
Western mathematics, or the English language, or (most commonly) some
synthesis of the two. Most of those syntheses are awkward, but some are
graceful.

However, the number of human languages is incredibly vast, and many of
them use very different structures from English. I believe that the role
English plays, as a model for the overwhelming majority of programming
languages, is very unlikely to last forever.

(Human languages also have an incredible virtue that, if I ever have
children, I will fervently want a programming language to have: all
spoken languages are easy for a child to learn. In fact, all spoken
languages are **inevitable** for a child to learn, under the right
circumstances.)

FlexVerb demonstrates what a programming language based on Latin and
Ancient Greek might look like, because those are the two human languages
I know the most about, after English.

## Word order and transformation in classical Western languages

Classical Western languages communicate a word's grammatical purpose not
through the word's location in the sentence, but through its form. If
you want to say "farmer," in Latin, you can't, at least, not yet. There
isn't enough information to determine the shape of the word, because the
shape of the word will depend on how you use it. So you have to also
choose its use case.

(I hope it's obvious how a language where it is impossible to say a word
until you've determined its purpose could be useful for training young
programmers.)

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
that it was the *farmer* who said it (as opposed to the goatherd).
Since word order didn't play the central role in Latin or Greek grammar
which it plays in English grammar, writers were free to use it for more
subtle purposes. This is a freedom which code could, at least in theory,
benefit from.

## FlexVerb brings this language feature to code

FlexVerb is a tiny toy language, implemented in Ruby via [Parslet](http://kschiess.github.com/parslet/),
in which token order is inconsequential.

For example:

    verb(print) direct-object("hello world")

The verb is `print`, the object is `"hello world"`. You can abbreviate
those terms:

    v(print) o("hello world")

More importantly, you can switch them around:

    o("hello world") v(print)

So if you print "hello world", and then you print something else, you
would use the first form.

    v(print) o("hello world")
    v(print) o("I like turtles")

But you would use the second form if you first print "hello world," and
next you say it out loud through a speech synthesizer (like the `say`
command in OS X).

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

Add permissive whitespace:

    v(render)   a(welcome)        o(message)
    v(email)    a(confirmation)   o(message)

It's really easy to see how the above code sample could turn into a
pair of `message` classes which have different content, and which each
implement their `send` function slightly differently. In Ruby:

    WelcomeMessage.send
    ConfirmationMessage.send

Likewise, it's really easy to see how the following FlexVerb code could
get shorter with Ruby's `tap`, or a `with` statement like those found in
[JavaScript](https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Statements/with)
and [Python](http://docs.python.org/release/2.5/whatsnew/pep-343.html):

    o("hello world")   v(print)
    o("hello world")   v(email)
    o("hello world")   v(render)
    o("hello world")   v(say)

Although FlexVerb has plenty of silly failings, it has one really
wonderful advantage: it suggests refactorings very rapidly. It's really
easy to look at FlexVerb code and spot alternative ways to structure it.
The restructuring is really easy too; it's a zero-cost thing to move
terms around and see which ones line up most easily, which in my opinion
is a good first step in any refactoring anyway.

This echoes one of the virtues of human classical languages.

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

In a language like this, syntax highlighting is crucial, because
you really want the `verb()` and `direct-object()` markers to
fade into the background. (Good syntax highlighting for Lisp
de-emphasizes parentheses for the same reason.) So FlexVerb includes
a syntax highlighting file for Vim. This is not a fully-fledged
[`pathogen`](https://github.com/tpope/vim-pathogen) plugin, and no other
text editors are currently supported, but pull requests are welcome.

<img src="http://s3.amazonaws.com/giles/flexverb_032813/syntax.png">

## Epic humblebrag (or maybe just crazybrag)

The syntax definition for FlexVerb tells Vim to treat the `v()` stuff as
comments, de-emphasizing them in most color schemes, while highlighting
the actual parts of speech distinctly. This allows you to recognize the
purpose of a term as soon as you see it, without having to figure it out
from the `verb()` or `direct-object()` markers, and that's actually how
I first discovered syntax highlighting. I invented syntax highlighting
independently long before I ever saw it in a text editor, back when I
was studying Latin for fun after dropping out of college. I realize that
every part of that last sentence is insane, but it's all true.

I was taking a class through a local university's extension
program. We were reading [a book in Latin by the philosopher
Cicero](http://en.wikipedia.org/wiki/Laelius_de_Amicitia). All the
different "agricola" and "agricolam" permutations were hard to remember,
but easy to look up and label, so I'd first underline each word in a
sentence with a particular color to indicate the word's grammatical
function, and then read the whole sentence through.

## Math

I haven't implemented this, but here's how I imagine it working.

    subject(23) verb(times) direct-object(5)

corresponds to

    23 * 5

which is how Ruby models basic math, because `*` is really just a method
on the object `23`. This equivalent Ruby makes the underlying semantics
more explicit:

    23.* 5

Meanwhile,

    v(multiply) s(23) o(5)

retains those exact same semantics, but phrases it in the way Lisps
phrase basic math. (FlexVerb should probably give you both `times` and
`multiply` for convenience.) To translate:

    (* 23 5)

Although FlexVerb does not yet support the `subject()` idea, FlexVerb
already permits this kind of flexible phrasing, and adding a math
implementation would be trivial. (Pull requests welcome!)

## Operator precedence

[Loren Segal provided a simple math challenge](https://twitter.com/lsegal/status/312778714737934336):

    5 + 3 * 12

That's easy!

    s(5) v(plus) o(s(3) v(times) o(12))

Admittedly, it's ugly, but with good syntax highlighting, you could
make it much easier to read. It would basically look like this:

      5    plus      3    times    12

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
less significant and rigid than it is in English.

Also, rather than two forms, "farmer" in Latin takes at least 10
different forms, and that's just for beginner-level stuff like "the
field was plowed by the farmers" and "this is the farmer's farm."

Ancient Greek is even more complicated. I think some words have a total
of 17 different *categories* of formal transformation. Also, the Romans
made Latin a standardized language everywhere in their empire, while
the independent Greek city-states each developed their own different,
idiosyncratic dialect. So that's not really 17 categories of formal
transformation per word; it's 17 categories of formal transformation per
word, per dialect. The total number of forms a word can take in Ancient
Greek is quite large.

I've also oversimplified English. There are situations where you can
shift around the position of the subject and the verb in an English
sentence and still get away with it. Examples:

    Quoth the raven, 'nevermore.'

    What light through yonder window breaks?

Both examples are not only archaic but also from poetry. I don't
actually know if this is a limitation of English, or a limitation of my
knowledge of English.

## Related projects

Perligata is a Perl library which enables you to write code purely
in Latin. It's insane even by Perl standards (although this is not
necessarily a bad thing).

http://www.csse.monash.edu.au/~damian/papers/HTML/Perligata.html

SQL syntax is also very interesting in this context, as I believe that
among computer languages in serious use today, it's the only one which
features prepositions, and also the one most closely based on English.

[Ithkuil](http://www.newyorker.com/reporting/2012/12/24/121224fa_fact_foer?currentPage=all)
is an invented human language designed to prevent ambiguity.

