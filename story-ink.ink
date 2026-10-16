VAR health = 50
VAR fullness = 30
VAR money = 20 // Ori: 20
VAR took_grab = false
VAR firstpick = "none"
VAR mealselected = "none"
VAR meal_points = 0
VAR ff_main = "none"
VAR ff_size = "none"
VAR ff_drink = "none"
VAR ff_price = 0
VAR location = "none"
VAR presenter = "none"

-> start //Ori start

=== start ===
Alarm: ~♪ # bg:room  # sprite:none
You: Urghh... what time is it...?
Narrator: (You looked up your phone.)
You: ...!?
You: It's almost 8! I have to catch the bus now!!
You: But I'm hungry... what should I eat first?

+ [An apple in your fridge (+2 health, +10 fullness)]
    ~ health += 2
    ~ fullness += 10
    You: Hope this helps...
    -> bus_stop
    
+ [Leftover chocolate cake in the fridge (-2 health, +15 fullness)]
    ~health -=2
    ~ fullness += 15
    You: Tasty!
    -> bus_stop

=== bus_stop ===
... # bg:bus_stop  # sprite:none
Narrator: (You finally reached the bus stop.)
Narrator: (But the bus had already passed.)
You: HEY! WAIT!
You: URGH! Why am I always like this!?
You: Great... Now I have to wait another 10 minutes for the bus...
You: And the class starts at 9.
You: ...
You: Or... should I call Grab?
You: But I only have RM{money} right now... and it costs RM15!

+ {money >= 15} [Call Grab (RM15)]
    ~ money -= 15
    ~ took_grab = true
    You: Goodbye, my money...
    -> campus
    
+ [Wait for the bus (Free)]
    You: I guess I'll wait...
    -> campus

=== campus ===
# bg:campus
# sprite:none

{
- took_grab:
    Narrator: (After 30 minutes, you finally arrived on campus with 10 minutes to spare before class.)
    You: Finally! I'm here!
    You: But my wallet is crying...
    You: At least I'm on time.
    You: ~♪
    -> class

- else:
    Narrator: (After a 30-minute bus ride and another 10-minute walk...)
    Narrator: (You felt tired.) (-5 fullness)
    ~ fullness -= 5
    Narrator: (You finally arrived on campus, but class had already started.)
    You: I'd better run to class!
    -> class
}

=== class ===

# bg:class
# sprite:none

You: Phew...
You: Luckily, class hasn't started yet.
You: Now let's... wait a second...

Rui: Hey, you're finally here. # sprite:rui_smile

You: Oh, hey! Rui!
You: And Honami too! Good morning! # left:rui_smile # right:honami_smile

Honami: Morning! We were worried about you.
Honami: What happened to you?

You: I went to bed at 2 a.m. last night... 
You: And I woke up at 8, so I missed the bus... # left:rui_shock # right:honami_shock

Honami: Oh my! That sounds like a stressful morning! # left:none # right:honami_shock

Honami: At least you made it here safely. # sprite:honami_smile

Rui: Well, at least you haven't been marked absent. Fufu~ # sprite:rui_smug

You: Erm... # left:rui_smug # right:honami_normal
You: Can you two at least let me sit down first?

Honami: Oh! Of course! # sprite:honami_smile

-> after_class

=== after_class ===
# bg:class
# sprite:none
Narrator: (A while later, the class ended.)
Narrator: (After class was dismissed, you quickly packed your bag.)
Narrator: (At the same time, you started to feel hungry.) (-25 fullness)
~ fullness -= 25
Honami: Hey, wanna have lunch with us later?
You: Of course! Where do y'all wanna go?
Honami: Erm... I was thinking about a nearby food court.
Honami: Most of the options there are healthy, which I think is good for us.

Rui: Oh? The food court nearby? # sprite:rui_smile
Rui: Although it might be a good choice, I'm thinking about having fast food.
Rui: It's affordable, tasty, and convenient.
Rui: Especially since our friend here had a rough morning...
Rui: A little treat won't hurt us, will it?

Honami: Well... it's up to them. # sprite:honami_listening
Honami: What do you think?

-> lunch_picking_first

=== lunch_picking_first ===

+ [Food court]
    ~ firstpick = "brokefuck"
    {
    - money <= 5:
    You: I'd like to go to the food court!
    You: I am broke anyway.
    -> dad_money
    
    - else:
    You: Let's go to the food court, then!
    You: I've still got plenty, hehe.
    -> dad_money
    }

+ [Fast food store]
    ~ firstpick = "fatfuck"
    {
    - money <= 5:
    You: Let's go have fast food!
    You: Maybe just some fries won't cost that much.
    -> dad_money
    
    - else:
    You: Yes! Rui's right!
    You: Let's go have a treat!
    -> dad_money
    }

=== dad_money ===
Phone: *rings* # sprite:none
You: Oh, sorry! One sec!
Narrator: (You picked up the phone.)
You: Huh?
Honami & Rui:...? # left:rui_normal # right:honami_normal
You: Alright, Dad, thank you!
Narrator: (You hang up the phone.)
You: My dad just sent me another RM20!
    ~money += 20
You: Finally, I can eat better now!

-> lunch_picking_second




=== lunch_picking_second ===
{
    //If user from foodcourt -> fastfood
    - firstpick == "fatfuck":
    Rui: Oh my, it looks like our little friend can enjoy a bit more now.
    Honami: ... # sprite:honami_listening
    Honami: Anyway, let's go together! Shall we?
    Honami: Or... you wanna go somewhere else?
    
        +[Change to food court]
        You: Hmm, on second thought...
        You: I think the food court is still the best!
        Honami: Oh, nice! Let's go!
        Rui:... # sprite:rui_normal
        ~ location = "foodcourt"
        -> foodcourt
        
        +[Stay your decision]
        You: Nah, Rui's idea sounds good!
        You: Probably next time!
        Honami: ...Sure. # sprite: honami_normal
        Honami: Let's go, then.
        ~ location = "fastfood"
        -> fastfood
        
    
    // If user from food court -> fast food
    - else:
    Honami: Oh! That's great! # sprite:honami_smile
    Honami: You will have more choices now!
    Rui: Sounds good~ *giggles* # sprite:rui_smile
    Rui: But my idea sounds good too, don't you think?
    
         +[Change to fast food restaurant]
        You: Hmm, on second thought...
        You: I think fast food is still the best!
        Rui: Fufu~ What a good pick, my friend.
        Honami:... # sprite:honami_normal
        ~ location = "fastfood"
        -> fastfood
        
        +[Stay your decision]
        You: Nah, Honami's idea sounds good!
        You: Probably next time!
        Rui: No problem, my friend~ # sprite:rui_smug
        Honami: Let's go! # sprite:honami_happy
         ~ location = "foodcourt"
        -> foodcourt
    
}


=== foodcourt ===
Narrator: (A while later, the three of you headed to the food court together.)
Honami: Oh my! # sprite:honami_shock
Honami: There are a lot of people here!
Rui: Yeah, especially since there are more choices here.
Rui: And you can take as much as you want.
Honami: Yeah, so a moderate portion would be nice.
Narrator: (The three of you queued up together.)
Narrator: (Because there were so many people, your stomach started growling as you waited.) (-5 fullness)
~ fullness -= 5
Honami: *Takes a small portion of rice, vegetables, and meat.*
Rui: *Takes moderate portions of rice and meat, but no vegetables.*
You: Hmm... # sprite:none
You: I am starving now...
You: What should I pick?

-> food_select
    
=== food_select ===
Menu: Balanced: Vegetables, chicken breast, and a small portion of rice.[NL]Large: More vegetables, a chicken drumstick, and a large portion of rice.[NL]Extra Large: A huge portion of vegetables, an L-shaped chicken drumstick, and two large portions of rice.
+ [Balanced meal (RM15, +35 fullness, +10 Health)]
    {
    - money >=15 :
        ~ money -= 15
        You: Good! I choose you!
        ~ mealselected = "fc_balance"
        ~ health += 10
        ~ fullness += 35
        -> foodcourt_food
    
    - else:
        You: I only have {money} left...
        You: Let's pick something else...
        -> food_select
    }
    
+ [Large portion (RM25, +50 Fullness, +3 Health)]
    {
    - money >=25 :
        ~ money -= 25
        You: I am really hungry.
        ~ mealselected = "fc_large"
        ~ health += 3
        ~ fullness += 50
        -> foodcourt_food
    
    - else:
        You: I only have {money} left...
        You: Let's pick something else...
        -> food_select
    }
    
+ [EXTRA LARGE PORTION (RM30, +70 Fullness, -3 Health)]
    {
    - money >=30 :
        ~ money -= 30
        You: Haha! Extra portion for extra happiness!
        ~ mealselected = "fc_xlarge"
        ~ health -= 3
        ~ fullness += 70
        -> foodcourt_food
    
    - else:
        You: I only have {money} left...
        You: Let's pick something else...
        -> food_select
    }
=== foodcourt_food ===
You: Alright! I'm done for now!
Honami: Are you done? Let's go sit at a table in the corner!
Rui: Fufu~ # sprite:rui_smug

Narrator: (The three of you sat together at a table in the corner, with Honami sitting beside you.)
Honami: Alright, here we go. # sprite:honami_normal
    {
    - mealselected == "fc_balance":
        Honami: Oh! You made a pretty good choice!
        Honami: I'm really happy for you.
        Rui: I mean, it looks really well-balanced.
        Rui: Unlike me... who refuses to eat any vegetables...
        Honami: *giggles* But you're still 182 cm tall!
        Narrator: (You watched them tease each other.)
        You: Well... let me start eating, then.
        # sprite:none
        -> chitchat
    
    
    
    - mealselected == "fc_large":
        Honami: Oh my... were you starving?
        Honami: That amount is... #left:rui_normal # right:honami_shock
        Rui: It's fine, no worries. # sprite:rui_smile
        Rui: Especially since our little friend had a rough morning earlier.
        Rui: Enjoy your meal! # sprite:rui_smug
        -> chitchat
    
    
    - else:
        Honami & Rui: ...!? # left:rui_shock # right:honami_shock
        Honami: Erm...
        Rui: ...interesting. # left:rui_smug
        Rui: Seems like you're really trying to enjoy yourself, aren't you?
        Honami: Yeah... I guess so... # right:honami_listening
        Honami: It's fine! Enjoy your meal! # sprite:honami_smile
        -> chitchat
    }





=== fastfood ===
Narrator: (A while later, the three of you headed to a nearby fast-food chain together.)
Rui: Hmm... # sprite:rui_normal
Rui: As usual, there aren't many people here at this time.
Honami: Yeah, unlike the food court.
Honami: It's usually full of people queuing up for food.
Rui: Fufu~ Let’s order, shall we? # left:rui_smile
Honami: Sure! # right:honami_smile

Narrator: (The three of you stood in front of the kiosk.)

Rui: I'll pick a simple burger set, with a sundae on the side…
Honami: Well… I'd like to order a burger à la carte, with less sauce.
Honami: How about you?

You: Huh… # sprite:none
You: Burger… fried chicken… 
You: A drink is a must!
You: Which one shall I pick?
-> ff_order_start


=== ff_order_start ===
~ meal_points = 0
~ ff_price = 0
-> ff_choose_main

=== ff_choose_main ===

+ [Burger (RM20, -3 Health, +40 Fullness)]
    ~ ff_main = "burger"
    ~ meal_points += 1
    -> ff_choose_size

+ [Fried Chicken (RM25, -4 Health, +45 Fullness)]
    ~ ff_main = "chicken"
    ~ meal_points += 2
    -> ff_choose_size


=== ff_choose_size ===
You: Now for the size...
+ [Regular (+RM0)]
    ~ ff_size = "regular"
    ~ meal_points += 1
    -> ff_choose_drink

+ [Large (+RM8, -5 Health, +25 Fullness)]
    ~ ff_size = "large"
    ~ meal_points += 2
    -> ff_choose_drink


=== ff_choose_drink ===
You: And... a drink!
+ [Sugar-free Drink]
    ~ ff_drink = "sugarfree"
    ~ meal_points += 1
    -> ff_checkout

+ [Sugary Drink (-3 Health)]
    ~ ff_drink = "sugary"
    ~ meal_points += 2
    -> ff_checkout
    
=== ff_checkout ===
{
- ff_main == "burger" and ff_size == "regular":
    ~ ff_price = 20

- ff_main == "burger" and ff_size == "large":
    ~ ff_price = 28

- ff_main == "chicken" and ff_size == "regular":
    ~ ff_price = 25

- else:
    ~ ff_price = 32
}

You: Alright! My total is RM{ff_price}!
You: I currently have RM{money}...

{
- money >= ff_price:
    ~ money -= ff_price
    You: Phew, I've got enough money!
    You: Well... let's enjoy our meal!
    -> ff_apply_stats

- else:
    You: WAIT!!
    You: I DON'T HAVE ENOUGH MONEY!!
    You: Let me pick something else instead...
    -> ff_order_start
}

=== ff_apply_stats ===

{
- ff_main == "burger":
    ~ health -= 3
    ~ fullness += 40

- else:
    ~ health -= 4
    ~ fullness += 45
}

{
- ff_size == "large":
    ~ health -= 5
    ~ fullness += 25
}

{
- ff_drink == "sugary":
    ~ health -= 3
}

// Limit stats between 0 and 100

{
- health < 0:
    ~ health = 0
- health > 100:
    ~ health = 100
}

{
- fullness > 100:
    ~ fullness = 100
- fullness < 0:
    ~ fullness = 0
}

-> ff_judge

=== ff_judge ===
{
    - meal_points <= 3:
    Honami: Hey, good choice! # sprite:honami_smile
    Honami: It's not the best, but it's still good enough!
    Honami: Now let's go find a place to sit!
    -> chitchat
    
    - meal_points == 4:
    Honami: Well... it's understandable. # sprite:honami_normal
    Rui: Fufu~ It's fine for me! # left:rui_smile # right:honami_normal
    Rui: I even added a sundae, so you're not the worst.
    Honami: ... # sprite:honami_normal
    Honami: Now let's go find a place to sit! # sprite:honami_smile
    -> chitchat
    
    - meal_points == 5:
    Honami & Rui: ...!? # left:rui_shock # right:honami_shock
    Honami: Erm...
    Rui: ...interesting. # left:rui_smug
    Rui: Seems like you're really trying to enjoy yourself, aren't you?
    Honami: Yeah... I guess so... # right:honami_listening
    Honami: It's fine! Now let's go find a place to sit! # sprite:honami_smile
    -> chitchat
    
    - meal_points == 6:
    Honami & Rui: ...!? # left:rui_shock # right:honami_shock
    Honami: Oh my...
    Rui: ...interesting. # sprite:rui_smug
    Rui: Seems like you're really trying to enjoy yourself, aren't you?
    Rui: But even I didn't expect you to enjoy high-calorie food more than I do.
    Honami: Yeah... # left:rui_smug # right:honami_listening
    Honami: It's fine! Now let's go find a place to sit! # sprite:honami_smile
    -> chitchat
}

=== chitchat ===
{
    - location == "fastfood":
        # bg:fastfood
        Honami: Over here!
        -> fr_chitchat
    
    - else:
        # bg:foodcourt
        -> fr_chitchat
}

=== fr_chitchat ===

# bg:class
# sprite:none

Narrator: (After lunch, the three of you headed back for your afternoon class.) # sprite:none

You: Urgh... what the hell is that? # sprite:none
You: Why do I suddenly feel so weird...? # sprite:none

{
- fullness >= 85:
    Narrator: (Your stomach feels uncomfortably full.) # sprite:none
    You: Oh god... # sprite:none
    You: I think I ate too much... # sprite:none
    Rui: Oh? Are you alright? # sprite:rui_normal
    You: I feel like I'm about to explode. # sprite:none
    Rui: Fufu~ What an impressive way to describe your lunch. # sprite:rui_smug
    Honami: Rui! Don't tease them! # sprite:honami_shock
    Honami: Maybe you should sit down and rest for a while.

- fullness <= 35:
    Narrator: (Your stomach suddenly lets out a loud growl.) # sprite:none
    You: WHAT?! # sprite:none
    You: I'm hungry AGAIN?! # sprite:none
    Honami: Eh?! But we just had lunch! # sprite:honami_shock
    Rui: My, my. Someone's stomach seems rather demanding. # sprite:rui_smug
    You: I'm not doing this on purpose! # sprite:none
    Honami: Maybe your lunch wasn't filling enough...

- else:
    Narrator: (You let out a long yawn.) # sprite:none
    You: Man... I'm getting sleepy. # sprite:none
    Rui: Already? The afternoon class hasn't even started. # sprite:rui_smile
    You: I KNOW! # sprite:none
    You: I just wanna go home... # sprite:none
    Honami: Hehe... Try to stay awake, okay? # sprite:honami_smile
}

Narrator: (The three of you settled into your seats.) # sprite:none

Narrator: (A few minutes later, the lecturer entered the classroom.) # sprite:none

Lecturer: Good afternoon, everyone. # sprite:none
Lecturer: Before we begin, I'd like you all to take a look at the screen. # sprite:none

Narrator: (The projector lights up.) # sprite:none

Narrator: (A familiar-looking topic appears on the screen.) # sprite:none

Lecturer: Today's topic is... # sprite:none
Lecturer: Healthy Eating Habits and Nutrition! # sprite:none

You: ... # sprite:none

You: You've gotta be kidding me. # sprite:none

Rui: Oho? What a fascinating coincidence. # sprite:rui_smug

Honami: Ahaha... That's exactly what we were talking about earlier! # sprite:honami_smile

You: Please don't remind me. # sprite:none

Lecturer: Now, can anyone tell me why portion control is important? # sprite:none

Narrator: (The lecturer looks around the classroom.) # sprite:none

Lecturer: How about you? # sprite:none

You: ...Me? # sprite:none

Rui: Fufu~ Good luck, my friend. # left:rui_smug # right:honami_smile

You: YOU LITTLE— # sprite:none

Honami: Shhh! The lecturer is waiting! # sprite:honami_shock

-> nutrition_question


=== nutrition_question ===

Lecturer: So, why is portion control important? # sprite:none

You: Erm... # sprite:none

+ [To avoid regularly eating more than our body needs.]
    You: Because regularly eating more than our bodies need can affect our health?

    Lecturer: Very good! # sprite:none
    Lecturer: Our nutritional needs are different, so choosing suitable portions matters. # sprite:none

    Honami: Nice answer! # sprite:honami_smile

    Rui: Fufu~ Seems like you were paying attention after all. # sprite:rui_smug

    You: EXCUSE ME?! # sprite:none

    -> nutrition_activity


+ [Because large portions are always unhealthy.]
    You: Because... large portions are always unhealthy? # sprite:none

    Lecturer: Not exactly. # sprite:none
    Lecturer: Larger portions aren't necessarily unhealthy. # sprite:none
    Lecturer: It depends on your needs, food choices, and eating habits. # sprite:none

    You: Oh... # sprite:none

    Honami: It's okay! At least you tried! # sprite:honami_smile

    Rui: Indeed. A brave attempt. # sprite:rui_smug

    You: Why does that sound like an insult? # sprite:none

    Rui: Oh? Whatever do you mean? *giggles*

    -> nutrition_activity


+ [Because I ate too much and now I regret everything.]
    You: BECAUSE I ATE TOO MUCH AND NOW I REGRET EVERYTHING! # sprite:none

    Narrator: (The entire classroom falls silent.) # sprite:none

    Honami: ...!? # sprite:honami_shock

    Rui: ...Pfft. # sprite:rui_smug

    Lecturer: ... # sprite:none

    Lecturer: Well... # sprite:none
    Lecturer: That's certainly one way to put it. # sprite:none

    Narrator: (A few students start laughing.) # sprite:none

    You: ... # sprite:none

    You: I WANT TO DISAPPEAR. # sprite:none

    Rui: Fufufu~ What a wonderful demonstration. # sprite:rui_smile

    Honami: Rui! Stop laughing! # sprite:honami_shock

    -> nutrition_activity


=== nutrition_activity ===

Lecturer: Alright, everyone. # sprite:none
Lecturer: Now, let's move on to our next activity. # sprite:none

You: Finally... # sprite:none

Lecturer: I want you to form groups of three. # sprite:none

Rui: Well, how convenient. # sprite:rui_smile

Honami: Looks like we're together again! # sprite:honami_smile

You: Yeah, at least that's one good thing. # sprite:none

Lecturer: Each group will discuss their lunch choices today. # sprite:none
Lecturer: Identify what was balanced and what could be improved. # sprite:none

You: ... # sprite:none

Rui: ...

Honami: ...

You: YOU HAVE GOT TO BE KIDDING ME. # sprite:none

Rui: Ahaha! It seems today's lesson was made just for us! # sprite:rui_smile

Honami: What a coincidence... # sprite:honami_normal

You: I DON'T WANT TO TALK ABOUT MY LUNCH ANYMORE! # sprite:none

Rui: Now, now. There's no need to be embarrassed. # sprite:rui_smug

{
- fullness >= 85:
    Rui: Although, considering how much you ate earlier...

    You: DON'T. # sprite:none

    Rui: I haven't even finished my sentence.

    Honami: Rui, please! # sprite:honami_shock

- fullness <= 35:
    Narrator: (Your stomach growls again.) # sprite:none

    You: ... # sprite:none

    Rui: ...Oh my. # sprite:rui_smug

    You: NOT AGAIN. # sprite:none

    Honami: Maybe you should have eaten a little more at lunch...

- else:
    Rui: Although you do look rather sleepy after lunch.

    You: I'm literally fighting for my life here. # sprite:none

    Honami: Ahaha... # sprite:honami_smile
}

Lecturer: You have five minutes to discuss. # sprite:none
Lecturer: After that, I'll randomly select a group to share their thoughts. # sprite:none

You: Alright, let's just finish this quickly. # sprite:none

Honami: Okay! I'll start! # sprite:honami_smile
Honami: I think including vegetables, protein, and carbohydrates can help create a balanced meal.

Rui: Quite right. # sprite:rui_normal
Rui: Though I must confess, vegetables aren't exactly my favourite.

Honami: You should really eat more vegetables, Rui... # sprite:honami_listening

Rui: Fufu~ I'll consider it.

You: YOU'VE BEEN SAYING THAT ALL DAY. # sprite:none

Rui: Have I? How curious. # sprite:rui_smug

Narrator: (The three of you continue discussing your meals.) # sprite:none

Narrator: (Five minutes later...) # sprite:none

Lecturer: Alright! Time's up! # sprite:none

Lecturer: Let's see which group should present first... # sprite:none

You: Please don't pick us. # sprite:none
You: Please don't pick us. # sprite:none
You: Please don't pick us. # sprite:none

Lecturer: Hmm... # sprite:none

Lecturer: How about the group sitting at the back? # sprite:none

You: ... # sprite:none

Honami: ... # sprite:honami_shock

Rui: Oya? # sprite:rui_smile

Lecturer: Yes, you three. # sprite:none

You: FUCK. # sprite:none

Rui: Fufu~ Language, my friend. # sprite:rui_smug

Lecturer: Who would like to represent your group? # sprite:none

Honami: Erm... # sprite:honami_listening

Rui: Well then... # sprite:rui_smug

You: ... # sprite:none

-> group_presentation


=== group_presentation ===

+ [Volunteer yourself]
    ~ presenter = "rei"
    You: Fine! I'll do it! # sprite:none

    Honami: Oh! Thank you! # sprite:honami_smile

    Rui: How reliable of you~ # sprite:rui_smile

    You: You owe me one. # sprite:none

    -> dinner


+ [Ask Honami to present]
    ~ presenter = "honami"
    You: Honami, please save us. # sprite:none

    Honami: E-Eh?! Me?! # sprite:honami_shock

    You: PLEASE. # sprite:none

    Honami: A-Alright! I'll try my best!

    Rui: Best of luck, Honami. # sprite:rui_smile

    -> dinner


+ [Let Rui handle it]
    ~ presenter = "rui"
    You: Rui. # sprite:none

    Rui: Hmm? # sprite:rui_normal

    You: You're presenting. # sprite:none

    Rui: Oh? How sudden. # sprite:rui_smug

    You: YOU STARTED THIS. # sprite:none

    Rui: Ahaha! Very well, then.
    Rui: Leave it to me.

    Honami: I have a bad feeling about this... # sprite:honami_listening

    -> dinner


=== dinner ===
# bg:class
# sprite:none

Narrator: (A few hours later, your afternoon class finally ended.) # sprite:none

{
    - presenter == "rei":
        You: Ugh... I was really nervous back then...
        Honami: You did your best! # sprite:honami_happy
        Rui: Yeah, you looked really confident just now... # left:rui_smug # right:honami_happy
        
    - presenter == "honami":
        Honami: Well, I'm glad everyone liked my presentation!
        Rui: Fufu~ You were just sharing facts, weren't you?
        Honami: Yeah, I'm glad the class is finally over.
        
    - else:
        Rui: Fufu~ It wasn't that hard anyway...
        Honami & You:... # sprite:none
        You: YOU LITERALLY CALLED THEM FAT FU-
        Honami: Hey. # sprite:honami_normal
        You: Sorry. # sprite:none
        You: Luckily, the class is over...
}

You: FINALLY! # sprite:none
You: I CAN GO HOME! # sprite:none

Narrator: (You quickly packed your belongings.) # sprite:none

Narrator: (After a long afternoon, you started feeling hungry again.) (-20 fullness) # sprite:none
~ fullness -= 20

Rui: My, my. Someone seems rather excited. # sprite:rui_smile

You: OF COURSE! # sprite:none
You: I'VE BEEN HERE ALL DAY! # sprite:none

Honami: Ahaha... It's been a long day, hasn't it? # sprite:honami_smile

Honami: By the way, have you decided what to eat for dinner?

You: Dinner? # sprite:none

{
- fullness >= 70:
    You: Hmm... I'm actually still quite full. # sprite:none

    Rui: Oh? Still recovering from lunch? # sprite:rui_smug

    You: DON'T START. # sprite:none

- fullness <= 30:
    You: I'M STARVING! # sprite:none

    Rui: Fufu~ What a surprise. # sprite:rui_smug

    Honami: Then we should get something to eat soon! # sprite:honami_smile

- else:
    You: Hmm... I could eat something. # sprite:none

    Honami: That's good! # sprite:honami_smile
}

Rui: Well then, shall we have dinner together? # sprite:rui_smile

You: AGAIN?! # sprite:none

Rui: Oh? Would you rather eat alone?

You: THAT'S NOT WHAT I MEANT! # sprite:none

Honami: Hehe... # sprite:honami_smile
Honami: I don't mind eating together!

Honami: Maybe we could visit the food court again.
Honami: There are plenty of choices for a balanced meal.

Rui: Hmm... # sprite:rui_normal
Rui: Or perhaps we could have something quick and convenient?

You: ...Fast food again? # sprite:none

Rui: Fufu~ You know me so well. # sprite:rui_smug

Honami: Rui... # sprite:honami_listening

You: ... # sprite:none

You: Let me check my wallet first. # sprite:none

Narrator: (You opened your wallet.) # sprite:none

You: RM{money}... # sprite:none

You: My poor wallet... # sprite:none

Rui: Oya? Having financial difficulties? # sprite:rui_smug

You: WHOSE FAULT IS THAT?! # sprite:none

Honami: Ahaha... # sprite:honami_smile
Honami: We can always go home and prepare something ourselves!

-> dinner_picking


=== dinner_picking ===

+ [Food court]
    You: Alright! Let's go to the food court! # sprite:none

    Honami: Sounds good! # sprite:honami_happy

    Rui: Fufu~ Very well, then. # sprite:rui_smile

    -> dinner_foodcourt


+ [Fast food restaurant]
    You: I think I'll go with Rui's idea! # sprite:none

    Rui: Excellent choice, my friend. # sprite:rui_smug

    Honami: Again...? # sprite:honami_listening

    You: DON'T JUDGE ME! # sprite:none

    -> dinner_fastfood


+ [Go home and cook]
    You: Nah, I think I'll just go home. # sprite:none

    You: I NEED TO SAVE MY MONEY. # sprite:none

    Honami: That's a good idea too! # sprite:honami_smile

    Rui: Fufu~ Your wallet must be relieved. # sprite:rui_smug

    -> dinner_home


=== dinner_foodcourt ===
# bg:foodcourt
# sprite:none

Narrator: (The three of you arrived at the food court.) # sprite:none

Honami: Oh! There are still plenty of choices! # sprite:honami_smile

Rui: Indeed. # sprite:rui_normal

You: Okay, let's see what I can afford... # sprite:none

Menu: Balanced meal: Rice, vegetables and chicken (RM12).[NL]Budget meal: Rice and egg (RM6). # sprite:none

+ {money >= 12} [Balanced meal (RM12)]
    ~ money -= 12
    ~ fullness += 35
    ~ health += 3

    You: Alright! A balanced meal it is! # sprite:none

    Honami: Great choice! # sprite:honami_happy

    Rui: It does look rather delicious. # sprite:rui_smile

    -> dinner_finish


+ {money >= 6} [Budget meal (RM6)]
    ~ money -= 6
    ~ fullness += 20

    You: This should be enough for now. # sprite:none

    Honami: Just make sure you're eating enough, okay? # sprite:honami_normal

    Rui: A rather economical decision. # sprite:rui_smug

    You: MY WALLET THANKS ME. # sprite:none

    -> dinner_finish


+ [Too expensive!]
    You: ... # sprite:none

    You: Never mind. I'm broke. # sprite:none

    Rui: Oh dear. # sprite:rui_normal

    Honami: It's okay! You can still prepare something at home. # sprite:honami_smile

    -> dinner_home


=== dinner_fastfood ===
# bg:fastfood
# sprite:none

Narrator: (The three of you entered the nearby fast food restaurant.) # sprite:none

Rui: Ah, that familiar smell~ # sprite:rui_smile

Honami: You really do enjoy fast food, don't you? # sprite:honami_normal

Rui: Fufu~ I simply appreciate its convenience.

You: Anyway, what should I order? # sprite:none

Menu: Chicken burger set: Burger, fries and soft drink (RM15).[NL]Regular burger: Burger only (RM8). # sprite:none

+ {money >= 15} [Chicken burger set (RM15)]
    ~ money -= 15
    ~ fullness += 45

    You: YES! A FULL MEAL! # sprite:none

    Rui: Fufu~ Someone's having a good evening. # sprite:rui_smug

    Honami: Just remember to enjoy it in moderation, okay? # sprite:honami_smile

    -> dinner_finish


+ {money >= 8} [Regular burger (RM8)]
    ~ money -= 8
    ~ fullness += 25

    You: Just a burger for me! # sprite:none

    Rui: A simple but satisfying choice. # sprite:rui_smile

    Honami: Hehe, enjoy your dinner! # sprite:honami_smile

    -> dinner_finish


+ [I can't afford this!]
    You: ... # sprite:none

    You: WHY IS EVERYTHING SO EXPENSIVE?! # sprite:none

    Rui: Ahaha... Perhaps another time. # sprite:rui_smile

    Honami: Let's head home then! # sprite:honami_normal

    -> dinner_home


=== dinner_home ===
# bg:room
# sprite:none

Narrator: (After saying goodbye to Rui and Honami, you finally returned home.) # sprite:none

You: HOME SWEET HOME! # sprite:none

Narrator: (You checked the ingredients in your kitchen.) # sprite:none

You: Hmm... # sprite:none

You: What should I make? # sprite:none

+ [Rice, egg and vegetables]
    ~ fullness += 35
    ~ health += 3

    You: Nice! A proper dinner! # sprite:none

    You: Honami would be proud of me. # sprite:none

    -> dinner_finish


+ [Instant noodles]
    ~ fullness += 25

    You: Instant noodles it is! # sprite:none

    You: Quick, cheap and easy! # sprite:none

    You: Rui would probably approve... # sprite:none

    -> dinner_finish


=== dinner_finish ===

# sprite:none

Narrator: (After dinner, your stomach finally feels satisfied.) # sprite:none

You: Phew... # sprite:none

You: What a day... # sprite:none

Narrator: (You checked your remaining money.) # sprite:none

You: RM{money} left... # sprite:none

You: ... # sprite:none

You: I REALLY NEED TO MANAGE MY MONEY BETTER. # sprite:none

-> ending_check


=== ending_check ===
# bg:room
# sprite:none

Narrator: (After a long day, you finally returned home.) # sprite:none

You: I'M FINALLY HOME! # sprite:none

Narrator: (You dropped your bag and sat on your bed.) # sprite:none

You: What a day... # sprite:none

Narrator: (You checked your current status.) # sprite:none

You: Health: {health} # sprite:none
You: Fullness: {fullness} # sprite:none
You: Money: RM{money} # sprite:none

You: Hmm... # sprite:none

Narrator: (Suddenly, your phone vibrated.) # sprite:none

Phone: *Ding!* # sprite:none

Honami: Hey! Did you get home safely?

Rui: Fufu~ I wonder how our little friend is doing.

You: Oh, these two again... # sprite:none

{
- fullness >= 85:
    -> ending_food_coma

- fullness <= 20:
    -> ending_starvation

- money <= 3:
    -> ending_financial

- health >= 54 && fullness >= 35 && fullness <= 80:
    -> ending_healthy

- else:
    -> ending_normal
}


=== ending_healthy ===
# bg:room
# sprite:none

Narrator: (You look back at your choices throughout the day.) # sprite:none

You: You know what? # sprite:none

You: I think I did pretty well today! # sprite:none

Honami: Oh? That's great! # sprite:honami_smile

Honami: Did you manage to have a balanced dinner?

You: Yep! And I'm feeling pretty good! # sprite:none

Rui: Oho? How impressive. # sprite:rui_smile

Rui: It seems you've been making some thoughtful decisions today.

You: OF COURSE! # sprite:none

Honami: Hehe! I'm proud of you! # sprite:honami_happy

Rui: Perhaps I should learn something from you as well. # sprite:rui_smile

You: Especially about eating vegetables. # sprite:none

Rui: ... # sprite:rui_smile

Rui: Ahaha... Let's not get carried away, shall we? # sprite:rui_smug

You: RUI.

# sprite:none

Narrator: (You ended your day feeling satisfied.) # sprite:none

Narrator: (You learned that balanced meals, suitable portions, and mindful food choices can support your well-being.) # sprite:none

Narrator: (Small choices can make a difference over time!) # sprite:none

Narrator: (ENDING 1: HEALTHY SURVIVOR) # sprite:none

-> END

=== ending_financial ===
# bg:room
# sprite:none

Narrator: (You opened your wallet one last time.) # sprite:none

You: ... # sprite:none

You: RM{money}. # sprite:none

You: ... # sprite:none

You: WHERE DID ALL MY MONEY GO?! # sprite:none

Narrator: (You checked your spending throughout the day.) # sprite:none

You: Transportation... # sprite:none

You: Lunch... # sprite:none

You: Dinner... # sprite:none

You: OH MY GOD. # sprite:none

Rui: Oya? What's wrong? # sprite:rui_normal

You: I'M BROKE. # sprite:none

Rui: Oh dear. # sprite:rui_smile

Rui: It seems your stomach survived...

Rui: But your wallet didn't. Fufu~ # sprite:rui_smug

You: THIS IS NOT FUNNY! # sprite:none

Honami: Oh my... # sprite:honami_shock

Honami: Maybe we should plan a budget together next time!

You: PLEASE. # sprite:none

Rui: Well, on the bright side... # sprite:rui_smile

You: WHAT BRIGHT SIDE?! # sprite:none

Rui: At least you've gained some valuable experience. # sprite:rui_smug

You: I LOST MY MONEY, RUI. # sprite:none

Rui: Precisely. # sprite:rui_smug

# sprite:none

Narrator: (You stared at your nearly empty wallet.) # sprite:none

Narrator: (You learned that managing your food budget is just as important as choosing what to eat.) # sprite:none

Narrator: (Planning meals and spending wisely can help you make affordable, balanced choices.) # sprite:none

Narrator: (ENDING 2: FINANCIAL DISASTER) # sprite:none

-> END


=== ending_food_coma ===
# bg:room
# sprite:none

Narrator: (You slowly lay down on your bed.) # sprite:none

You: Urghhh... # sprite:none

You: I FEEL SO FULL... # sprite:none

Narrator: (Your stomach feels uncomfortably heavy.) # sprite:none

You: Why did I eat so much today... # sprite:none

Phone: *Ding!* # sprite:none

Honami: Are you okay? # sprite:honami_shock

You: NO. # sprite:none

You: I THINK I ATE TOO MUCH. # sprite:none

Honami: Oh dear...

Honami: Maybe you should rest for a while.

Rui: Oho? # sprite:rui_smug

Rui: So the consequences of your grand feast have finally arrived?

You: SHUT UP. # sprite:none

Rui: Fufu~ But you seemed so enthusiastic earlier. # sprite:rui_smile

You: I REGRET EVERYTHING. # sprite:none

Honami: Rui! Stop teasing them! # sprite:honami_shock

Rui: Ahaha! My apologies. # sprite:rui_smile

Honami: Next time, try choosing portions based on how hungry you actually feel. # sprite:honami_listening

You: YEAH... # sprite:none

You: NOTED... # sprite:none

# sprite:none

Narrator: (You decided to relax and let your stomach settle.) # sprite:none

Narrator: (You learned that eating beyond comfortable fullness can leave you feeling uncomfortable.) # sprite:none

Narrator: (Listening to your hunger and fullness signals can help you choose suitable portions.) # sprite:none

Narrator: (ENDING 3: FOOD COMA) # sprite:none

-> END

=== ending_starvation ===
# bg:room
# sprite:none

Narrator: (You finally sat down on your bed.) # sprite:none

You: Phew... # sprite:none

Narrator: (Suddenly...) # sprite:none

SFX: *GRRRRRRRR* # sprite:none

You: ... # sprite:none

You: WHAT?! # sprite:none

Narrator: (Your stomach growled loudly.) # sprite:none

You: I'M STILL HUNGRY?! # sprite:none

You: HOW IS THAT EVEN POSSIBLE?! # sprite:none

Phone: *Ding!* # sprite:none

Honami: Hey! How was your dinner? # sprite:honami_smile

You: I'M HUNGRY. # sprite:none

Honami: Eh?! Again?! # sprite:honami_shock

Rui: My, my. # sprite:rui_smug

Rui: It seems your stomach has some unfinished business.

You: I JUST WANT TO EAT. # sprite:none

Honami: Maybe you didn't eat enough today... # sprite:honami_shock

Honami: If you're still hungry, perhaps you could prepare something nutritious! # sprite:honami_smile

Rui: Indeed. # sprite:rui_normal

Rui: Even the most determined student needs enough energy to survive the day.

You: I'M GOING TO RAID THE FRIDGE. # sprite:none

Rui: Fufu~ Best of luck. # sprite:rui_smug

# sprite:none

Narrator: (You headed straight to the kitchen.) # sprite:none

Narrator: (You learned that skipping meals or eating too little may leave you feeling hungry and low on energy.) # sprite:none

Narrator: (Eating enough and choosing satisfying, balanced meals can help support your daily activities.) # sprite:none

Narrator: (ENDING 4: THE HUNGRY SURVIVOR) # sprite:none

-> END


=== ending_normal ===
# bg:room
# sprite:none

Narrator: (You stretched your arms and relaxed.) # sprite:none

You: Ahhh... # sprite:none

You: Finally, some peace. # sprite:none

Phone: *Ding!* # sprite:none

Honami: How are you feeling? # sprite:honami_smile

You: Pretty normal, I guess. # sprite:none

Rui: Oho? After everything that happened today? # sprite:rui_smile

You: DON'T REMIND ME. # sprite:none

Honami: Hehe! At least we had fun together! # sprite:honami_happy

You: Yeah, I guess so. # sprite:none

Rui: And we certainly enjoyed some interesting meals. # sprite:rui_smug

You: Especially YOU. # sprite:none

Rui: Whatever could you mean? Fufu~ # sprite:rui_smug

Honami: Anyway, let's try to make good choices tomorrow too! # sprite:honami_happy

You: I'll try... # sprite:none

You: NO PROMISES THOUGH. # sprite:none

Rui: Ahaha! Fair enough. # sprite:rui_smug

# sprite:none

Narrator: (You put your phone aside and prepared for bed.) # sprite:none

Narrator: (Some of your choices were better than others, but that's part of everyday life.) # sprite:none

Narrator: (Healthy eating isn't about being perfect.) # sprite:none

Narrator: (It's about developing balanced and sustainable habits over time.) # sprite:none

You: ALRIGHT! # sprite:none

You: GOOD NIGHT, WORLD! # sprite:none

Narrator: (ENDING 5: JUST ANOTHER DAY) # sprite:none

-> END