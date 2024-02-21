How often have you found yourself thinking:

What’s the point of this code?
Isn’t this option deprecated?
Is this comment out-of-date? I don’t think it describes what I’m seeing.
This pull request is massive, where do I start?
Where did this bug come from?
These questions all reflect the limitations of collaboratively-developed source code as a communication medium. While there are ways to mitigate these issues (code comments, style guides, documentation requirements), we still inevitably find ourselves spending hours on just trying to understand code. Luckily, the tools needed to solve these problems have been here all along!

Commits in Git repositories are more than just save points or logs of incremental progress in a larger project. In the words of GitHub’s “Git Guides“:
[Commits] are snapshots of your entire repository at specific times…based around logical units of change. Over time, commits should tell a story of the history of your repository and how it came to be the way that it currently is.


Commits are a firsthand historical record of exactly how and why each line of code came to be. They even come with human-readable messages! As a result, a repository’s commit history is the best tool a developer can use to explain and understand code.
It’s been my experience that commits are most effective when they’re tweaked and polished to deliberately convey a message to their audiences: reviewers, other contributors, and even your future self. This post will:

Introduce some guidelines for organizing and revising commits.
Outline pragmatic approaches for applying those guidelines.
Describe some of the practical applications of a well-crafted commit history.
Writing better commits
Software development involves a lot of creativity, so your commits will reflect the context of your changes, your goals, and your personal style. The guidelines below are presented to help you utilize that creative voice to make your commits effective tools of communication.

As you read these guidelines, don’t worry about how you’ll be able to utilize all of this advice in the midst of writing code. Although you may naturally incorporate them into your development process with practice, each can be applied iteratively after you’ve written all of your code.

📚 Structure the narrative
Like your favorite novel, a series of commits has a narrative structure that contextualizes the “plot” of your change with the code. Before any polishing, the narrative of a branch typically reflects an improvised stream of consciousness. It might contain:

A commit working on component A, followed by one on component B, followed by one finishing component A
A multi-commit detour into trying again and again to get the right CI syntax
A commit fixing a typo from an earlier commit
A commit with a mixed bag of all of the review feedback
A merge commit resolving conflicts with the main branch
Although an accurate retelling of your journey, a branch like this tells a “story” that is neither coherent nor memorable.

The problem
Disorganized commits that eschew a clear narrative will affect two people: the reviewer, and the developer themself.

Reviewing commit-by-commit is the easiest way to avoid being overwhelmed by the changes in a sufficiently large pull request. If those commits do not tell a singular, easy-to-follow story, the reviewer will need to context-switch as the author’s commits jump from topic to topic. To ensure earlier commits properly set up later ones (for example, verifying a newly-created function is used properly), the reviewer ultimately needs to piece together the narrative on their own; for each commit, figure out which earlier changes establish the relevant background context and tediously click back and forth between them. Alternatively, they’ll remember some vague details and simply assume earlier commits properly set up later ones, failing to identify potential issues.

But how does a scatterbrained narrative hurt the developer? A developer’s first instinct when working on a new project is often to hack on it until they get something functional. Fluctuating between “fun” and “frustrating,” this approach eventually yields good results, but it’s far from efficient. Jumping in without a plan – the mindset of following a narrative – makes that process slower than it needs to be.

The solution
Outline your narrative, and reorganize your commits to match it.

The narrative told by your commits is the vehicle by which you convey the meaning of your changes. Also, like a story, it can take on many structures or forms.



Your branch is your story to tell. While the narrative is up to you, here are some editorial tips on how to keep it organized:

DO	DON’T
Write an outline and include it in the pull request description.	Wait until the end to form the outline – try using it to guide your work!
Stick to one high-level concept per branch.	Go down a tangentially-related “rabbit hole”.
Add your “implement feature” commit immediately after the refactoring that sets it up.	Jump back and forth between topics throughout your branch.
Treat commits as “building blocks” of different types: bugfix, refactor, stylistic change, feature, etc.	Mix multiple building block types in a single commit.
How do I do it?

ℹ️ The branch used in this example can be found here – clone it and follow along for some hands-on practice!
 

Suppose I’ve been working on a script that lets me load an image, make some change to it (for example, invert the colors), then either display it or save the modified image to a new location. My branch – which I’ve named feature/image-modifier – currently looks like this (displayed with newest commits at the bottom):


Before modifying the branch, I want to outline the narrative. In this case, my “story” is:

Create the basic script (no options, just read & display the image).
Add --output option.
Add image manipulation options (--invert and --grey/--gray).
Add GitHub Actions CI for basic linting.
To reorder the commits to match this outline, I’ll use an interactive rebase, invoked with git rebase -i.

git rebase -i main

After initiating the rebase, my default editor opens with the git-rebase-todo file listing commits ordered from oldest (top) to newest (bottom). Now, I simply cut and paste the lines into the new order I want for the branch:

Before

pick 6a885eb WIP
pick 692f477 Finish script
pick b3348a0 Add --invert and --grey
pick 9512893 Add --output option
pick 1689371 Add GitHub Actions CI .yml
pick 6af4476 Add requirements.txt + other build fixes
pick 9cd6412 Let users use --gray option spelling
# Rebase 00a3ff6..9cd6412 onto 00a3ff6 (7 commands)
# ...
After

pick 6a885eb WIP
pick 692f477 Finish script
pick 9512893 Add --output option                        # moved
pick b3348a0 Add --invert and --grey
pick 9cd6412 Let users use --gray option spelling       # moved
pick 1689371 Add GitHub Actions CI .yml
pick 6af4476 Add requirements.txt + other build fixes
# Rebase 00a3ff6..9cd6412 onto 00a3ff6 (7 commands)
# ...
Once I save and close my editor, the rebase begins. I encounter some minor rebase conflicts, but I’m able to resolve them and run git rebase --continue until all remaining commits are applied to the branch in their new order:



⚛️ Resize and stabilize the commits
Although the structure of a commit series can tell the high-level story of an author’s feature, it’s the code within each commit that creates software. Code itself can be complex, dense, and cryptic but in order to collaborate, others need to understand it.

The problem
The cognitive burden of parsing code is exacerbated by having either too much or not enough information presented at once. Too much, and your reader will need to read and understand multiple conceptually-different topics that could get jumbled, misinterpreted, or simply missed; too little, and your reader will develop an incomplete mental model of a change.

For a reviewer, one of the big benefits of a commit-by-commit review is – like individual lectures in a semester-long course – pacing the development of their mental model with small, easy-to-digest changes. When a large commit doesn’t provide that sustainable learning pace, the reviewer may fail fail to identify questionable architectural decisions because they conflate unrelated topics, or even miss a bug because it’s in a section seemingly irrelevant to the impacted feature.

You might think reviewers’ problems would be solved with commits as small as possible, but an incomplete change leaves them unable to evaluate it fully as they read it. When a later commit “completes” the change, a reviewer may not easily draw connections to the earlier context. This is made worse when a later commit undoes something from the earlier, partial commit. The “churn” in these situations leads to the same weakened mental model – and same consequences – as when dealing with too-large commits.

Poorly-sized commits present more tangible issues as well. Most apparent is the inability to roll back your repository to a commit (for example, when debugging a strange feature interaction). Incomplete changes often fail to build, so a developer will be stuck searching nearby commits for a fix. Similarly, a bug narrowed down to a massive commit requires teasing apart its intermixed changes, a potentially more difficult task than it was during the initial review due to loss of institutional project knowledge over time.

The solution
Make each commit both “small” and “atomic.”

To best convey your story, commits should minimize the effort needed to build a mental model of the changes they introduce. With effort tied to having a “just right” amount of information, the key to a good commit is fitting into quantified upper and lower bounds on that information.

A small commit is one with minimal scope; it does one “thing.” This often correlates to minimizing the modified lines of cone, but that isn’t a firm requirement. For example, changing the name of a commonly-used function may modify hundreds of lines of code, but its constrained scope makes it simple to both explain and review.

A commit is atomic when it is a stable, independent unit of change. In concrete terms, a repository should still build, pass tests, and generally function if rolled back to that exact commit without needing other changes. In an atomic commit, your reader will have everything they need to evaluate the change in the commit itself.

How do I do it?

Let’s return to the “image modifier” script from earlier. Where we last left it, the feature/image-modifier branch looked like this:


Commits can be split and combined to adjust their size and scope. I’ll start by identifying the commits I want to split:
– 3f1e287 (Add --invert and --grey) – while this commit is small, it contains two distinct “things”: the --invert option, and the --grey option. In keeping with the principle of smallness in scope, then, I want to create one commit for each option.
– 60f352d (Add requirements.txt + other build fixes) – the addition of requirements.txt is necessary for the script to run successfully in _any_ context, whereas the “other build fixes” all pertain specifically to the GitHub Action CI definition. Because the two deal with ultimately different issues, relevant to different aspects of the narrative, I will split them.

To split them, I’ll follow the method described in the Git docs and rebase with the commits I want to split marked with edit, or e:
Before

pick 6a885eb WIP
pick 692f477 Finish script
pick d897cc6 Add --output option
pick 3f1e287 Add --invert and --grey
pick 1c26b4c Let users use --gray option spelling
pick d113307 Add GitHub Actions CI .yml
pick 60f352d Add requirements.txt + other build fixes
After

pick 6a885eb WIP
pick 692f477 Finish script
pick d897cc6 Add --output option
edit 3f1e287 Add --invert and --grey # pick -> edit
pick 1c26b4c Let users use --gray option spelling
pick d113307 Add GitHub Actions CI .yml
edit 60f352d Add requirements.txt + other build fixes # pick -> edit
Upon saving and closing my editor, the rebase applies commits until it reaches the first split candidate. For each split, I undo the original commit with git reset, then divide its contents into two appropriately-sized new ones (using git add -p and git commit), then finally continue the rebase with git rebase --continue. When the rebase completes, the commits are split as indicated earlier:

The next step is to combine the commits that are incomplete or otherwise too small:
– 6a885eb (WIP) and 692f477 (Finish script) – the former is an incomplete commit, and the latter completes it to form the minimal stable version of the script.
– 692f477 (Finish script) and 54b3e6d (Create requirements.txt) – requirements.txt is needed to install dependencies in the initial commit’s “minimal” script.
– 9c049cb (Add GitHub Actions CI .yml) and (73e6da5) Fix CI build – the CI fixes are all corrections to the initial GitHub Actions script needed for build to succeed.

I do this with another interactive rebase, this time using fixup (or f) or squash (or s) depending on whether I’m silently correcting unintentional issues in a commit or combining commits with an entirely new message, respectively:

Before

pick 6a885eb WIP
pick 692f477 Finish script
pick d897cc6 Add --output option
pick 18dc6af Add --invert option
pick babc825 Add --grey option
pick 851f2a0 Let users use --gray option spelling
pick 9c049cb Add GitHub Actions CI .yml
pick 54b3e6d Create requirements.txt
pick 73e6da5 Fix CI build
After

pick 6a885eb WIP
squash 692f477 Finish script # pick -> squash
fixup 54b3e6d Create requirements.txt # moved, pick -> fixup
pick d897cc6 Add --output option
pick 18dc6af Add --invert option
pick babc825 Add --grey option
pick 851f2a0 Let users use --gray option spelling
pick 9c049cb Add GitHub Actions CI .yml
fixup 73e6da5 Fix CI build # pick -> fixup
When I close the editor, I’m stopped to create a new commit message for the combined “WIP” and “Finish script” commits due to the use of squash:

# This is a combination of 2 commits.
# This is the 1st commit message:

WIP

# This is the commit message #2:

Finish script

Now reads image from input

# Please enter the commit message for your changes. Lines starting
...
I’ll change the commit message to “Create initial image modifier script,” save my editor and continue. The remaining `fixup`s are applied without any conflicts, so the rebase completes with commits combined as specified:


❓ Explain the context
Commits are more than just the code they contain. Despite there being no shortage of jokes about them, commit messages are an extremely valuable – but often overlooked – component of a commit. Most importantly, they’re an opportunity to speak directly to your audience and explain a change in your own terms.

The problem
Even with a clear narrative and appropriately-sized commits, a niche change can still leave readers confused. This is especially true in large or open-source projects, where a reviewer or other future reader (even yourself!) likely won’t be clued into the implementation details or nuances of the code you’ve changed.

Code is rarely as self-evident as the author may believe, and even simple changes can be prone to misinterpretation. For example, what may appear to be a bug may instead be a feature implemented to solve an unrelated problem. Without understanding the intent of the original change, a developer may inadvertently modify an expected user-facing behavior. Conversely, something that appears intentional may have been a bug in the first place. A misinterpretation could cause a developer to enshrine a small mistake as a “feature” that hurts user experience for years.

Even in a best-case scenario, poorly explained changes will slow down reviewers and contributors as they attempt to interpret code, unnecessarily wasting everyone’s time and energy.

The solution
Describe what you’re doing and why you’re doing it in the commit message.

Because you’re writing for an audience, the content of a commit message should clearly communicate what readers need to understand. As the developer, you should already know the background and implementation well enough to explain them. Rather than write excessively long (and prone to obsoletion) code comments or put everything into a monolithic pull request description, you can use commit messages to provide piecewise clarification to each change.

“What” and “why” break down further into high- and low-level details, all of which can be framed as four questions to answer in each commit message:

What you’re doing	Why you’re doing it
High-level (strategic)	Intent (what does this accomplish?)	Context (why does the code do what it does now?)
Low-level (tactical)	Implementation (what did you do to accomplish your goal?)	Justification (why is this change being made?)
How do I do it?

Looking back once again at the feature/image-modifier branch:

Before submitting for review, each of these commits should be rewritten to incorporate the intent, implementation, context, and justification of their respective change. For the sake of this example, I’ll reword only the “Let users use –gray option spelling” commit.

This commit isn’t the most recent one on the branch (in which case I could use git commit --amend to modify it), so I again need to use an interactive rebase to make changes to it. This time, the only thing I need to do is change the commit from pick to reword (or r):
Before

pick 096ee13 Create initial image modifier script
pick 381d3af Add --output option
pick 3e5e5f6 Add --invert option
pick 2d164e2 Add --grey option
pick bfa3f6f Let users use --gray option spelling
pick 3bf4ec4 Add GitHub Actions CI .yml
After

pick 096ee13 Create initial image modifier script
pick 381d3af Add --output option
pick 3e5e5f6 Add --invert option
pick 2d164e2 Add --grey option
reword bfa3f6f Let users use --gray option spelling # pick -> reword
pick 3bf4ec4 Add GitHub Actions CI .yml
After closing the git-rebase-todo, a new editor instance opens with the original commit message:

Let users use --gray option spelling
# Please enter the commit message for your changes. Lines starting
...
This message – like many one-line commit messages – only contains a vague description of the intent and is completely missing an explanation of how the change was implemented or why this change is needed.

When revising my commits, I like to order my “what” and “why” sections as follows:

Intent (as the title)
Context
Justification
Implementation
Applying that outline to the commit I’m editing here, I write approximately one (short) sentence for each item:

Add '--gray' option alias for '--grey'
If a user provides the option '--gray' (rather than the valid option
'--grey') to the image modifier script, they receive the error:
image-modifier.py: error: unrecognized arguments: --gray
Because both "grey" and "gray" are common spellings of the same word, allow
both to indicate the convert-to-greyscale operation by adding "--gray" to
the 'argparse' argument definition.
The above message covers all of the context a reader might need, but is a bit of an over-explanation for such a simple change. While it is essential that the message includes some form of intent/implementation/context/justification, it’s perfectly acceptable to tailor the level of detail to the complexity of the change. For example, a more concise – but still fully-explained – commit message might instead look like:

Add '--gray' option alias for '--grey'
Include '--gray' as an alternative name for '--grey' in the 'argparse'
definition so that users can specify either common spelling for the option.
Building better projects
Using the guidelines established above, you can mitigate the challenges of common software development tasks including code review, finding bugs, and root cause analysis.

Code review
Reviewing even the largest pull requests can be a manageable, straightforward process if you are able to evaluate changes on a commit-by-commit basis. Each of the guidelines detailed earlier focuses on making the commits readable; to extract information from commits, you can use the guidelines as a template.

Determine the narrative by reading the pull request description and list of commits. If the commits seem to jump between topics or address, leave a comment asking for clarification or changes.
Lightly scan the message and contents of each commit, starting from the beginning of the branch. Verify smallness and atomicity by checking that the commit does one thing and that doesn’t include any incomplete implementations. Recommend splitting or combining commits that are incorrectly scoped.
Thoroughly read each commit. Ensure the commit message sufficiently explains the code by first checking that implementation matches the intent, then that the code matches the stated implementation. Use the context and justification to guide your understanding of the code. If any of the requisite information is missing, ask for clarification from the author.
Finally, with a complete mental model of the commit’s changes and the overarching narrative, confirm the code is efficient and bug-free.
