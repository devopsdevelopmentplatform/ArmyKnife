# PreFace

Over the past 10 years or so, I've been a DevOps Engineering. Being a DevOps Engineer means your expected to do just about anything and everything.

I've been in IT over 25 years so, I've been prepared for this type of role for a long time. What I don't like about being a DevOps Engineer is that
every IT Manager who hires a DevOps Engineer has a different idea of what a DevOps Engineer is supposed to be doing. IT Managers hear all the buzzwords
and just automatically assume that this is what you should be doing. I don't think I've worked at any two companies doing the same thing. Its crazy.

Recently I worked for a company that really didn't have much work to do in the DevOps space. I spent most of my time doing support tickets. About 23 years ago I spent night after night
staying up till 3 or 4am studying, so I could get out of a job that does support tickets. I was definitely not happy.
So I started looking for another job.

The interview process was daunting to say the least.
I was an expert at Kubernetes, Terraform, Python, Docker, and CI/CD.
However, since every company has a different Idea about what a DevOps Engineer is supposed to do,
I got hammered with lets play "Stump the Chump", during the interviews.

I promised myself that I was not going to let that happen ever again. I thought man, what could I do to make sure I don't get caught with my pants
down and exercise my brain with DevOps Tasks every day. I made a list of all my career deficiencies. It started out with Makefiles. I noticed all the
Rockstars using Makefiles in all their projects they did. I quickly purchased two of the only Makefile books I could find. Oh my gosh those books
were terrible. It was like listening to a shop teacher in Jr. High School. So I started building my own tutorial on Makefile with what little information I 
could gleen from those two books. It started going so well, I was considering creating an Udemy class on Makefiles for Cloud/DevOps Engineers. One Makefile turned in to 5,
then 10. Pretty soon, I had the beginning of a DevOps Development Platform getting a workstation ready to create a Rockstar DevOps Engineer. 

As I moved forward with this so-called DevOps Development Platform I call ArmyKnife, I thought to myself, this is not a glorified setup script, this is so much more. I'm going to go 
the extra mile and show DevOps Engineers how to do things with best practices with all the possibilities to make sure your on your way to greatness. 

It has been challenging for sure. Trying to decide to spend my time adding features or expanding the current features with useful examples has been a struggle. I mean, we are talking
about DevOps Engineers here. Able to leap tall buildings in a single bound. Each of us has to be Superman. 

What I love about the ArmyKnife DevOps Development platform is that every Makefile, every tool that you install you get an opportunity to jump in and do something 
great. What do I mean by that? Lets take the Makefile.BashLib.mk file. With this one you setup a bash function library that integrates with your shell so that at
anytime you can call a function to do some devops task. The one that I included as an example is get_vault_credentials. This bash function reaches out to your
development vault server and extracts the credentials for Azure and exports them in your current shell. Why is this so great? You don't have to have them sitting
in your .bashrc or .zshrc file in clear text just waiting to get hacked. They are safe in your vault instance until you need them and disappear when you close your terminal.
OK, OK, I know the development vault instance is not over https but I'm working on that. I have a solution with mkcert and squid proxy, but I have not ironed it out yet.
Give me time. LOL.


