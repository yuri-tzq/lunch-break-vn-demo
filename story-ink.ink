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

-> start //Ori start

=== start ===
Alarm: ~♪ # bg:room  # sprite:none
You: Urghh... what time is it...?
Narrator: (You looked up your phone.)
You: ...!?
You: It's almost 8! I had to hop on the bus now!!
You: But I am hungry... what should I eat first?

+ [An apple in your fridge (+2 health, +10 fullness)]
    ~ health += 2
    ~ fullness += 10
    You: Hope this helps...
    -> bus_stop
    
+ [Left over chocolate cake in the fridge (-2 health, +15 fullness)]
    ~health -=2
    ~ fullness += 15
    You: Tasty!
    -> bus_stop

=== bus_stop ===
... # bg:bus_stop  # sprite:none
Narrator: (You finally reach the bus stop.)
Narrator: (But the bus had already passed.)
You: HEY! WAIT!
You: URGH! Why am I always like this!?
You: Great... Now I had to wait another 10 minutes for the bus...
You: And the class starts at 9.
You: ...
You: Or... should I call Grab?
You: But I only have {money} for now... and it cost RM15!

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
    Narrator: (After 30 minutes, you finally arrive on campus with 10 minutes to spare before class.)
    You: Finally! I'm here!
    You: But my wallet is crying...
    You: At least I am on time.
    You: ~♪
    -> class

- else:
    Narrator: (After a 30-minute bus ride and another 10-minute walk...)
    Narrator: (You felt tired.) (-5 fullness)
    ~ fullness -= 5
    Narrator: (You finally arrive on campus, but class has already started.)
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
Narrator: (A while later, the class has end.)
Narrator: (After dissmissed, you packed your bag nice and quickly.)
Narrator: (Which at the same time, you start to feel hungry.) (-25 fullness)
~ fullness -= 25
Honami: Hey. You wanna have lunch with us later? # sprite:honami_normal
You: Of course! Where do y'all wanna go?
Honami: Erm... I was thinking about a nearby food court.
Honami: Most of their choices provided are healthy, which I think it is good for us.

Rui: Oh? The food court nearby? # sprite:rui_smile
Rui: Although it might be a good choice, but I am thinking about having fast food.
Rui: Affordable, tasty and convenience.
Rui: Especially our friend here had a bad morning just now...
Rui: A little treat wont hurt us, isn't it?

Honami: Well... it's up to them. # sprite:honami_listening
Honami: How do you think?

-> lunch_picking_first

=== lunch_picking_first ===

+ [Food court]
    ~ firstpick = "brokefuck"
    {
    - money <= 5:
    You: I would like to go food court!
    You: I am broke anyway.
    -> dad_money
    
    - else:
    You: Let's go food court then!
    You: I still got plenty, hehe.
    -> dad_money
    }

+ [Fast food store]
    ~ firstpick = "fatfuck"
    {
    - money <= 5:
    You: Let's go have fast food!
    You: Maybe just a fries wont cost that much.
    -> dad_money
    
    - else:
    You: Yes! Rui's right!
    You: Let's go have a treat!
    -> dad_money
    }

=== dad_money ===
Phone: *rings* # sprite:none
You: Oh sorry! One sec!
Narrator: (You picked up the phone.)
You: Huh?
Honami & Rui:...? # left:rui_normal # right:honami_normal
You: Alright dad, thank you! # sprite:none
Narrator: (You hang up the phone.)
You: My dad just sent me another RM20!
    ~money += 20
You: Finally I can eat better now!

-> lunch_picking_second




=== lunch_picking_second ===
{
    //If user from foodcourt -> fastfood
    - firstpick == "fatfuck":
    Rui: Oh my, looks like our little friend can have more pleasure now. # sprite:rui_smug
    Honami: ... # sprite:honami_listening
    Honami: Anyway, let's go together! Shall we?
    Honami: Or... you wanna go somewhere else?
    
        +[Change to food court]
        You: Hmm, in a second thought...
        You: I think food court still the best!
        Honami: Oh nice! Let's go! # sprite:honami_happy
        Rui:... # sprite:rui_normal
        ~ location = "foodcourt"
        -> foodcourt
        
        +[Stay your decision]
        You: Nah, Rui's idea sounds good!
        You: Probably next time!
        Honami: ...Sure. # sprite: honami_normal
        Honami: Let's go then. 
        ~ location = "fastfood"
        -> fastfood
        
    
    // If user from food court -> fast food
    - else:
    Honami: Oh! That's great! # sprite:honami_smile
    Honami: You will have more choices now!
    Rui: Sounds good~ *giggles* # sprite:rui_smile
    Rui: But my idea sounds good too, don't you think?
    
         +[Change to fast food restaurant]
        You: Hmm, in a second thought... # sprite:none
        You: I think fast food still the best!
        Rui: Fufu~ What a good pick my friend. # sprite:rui_smile
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
Narrator: (A while later, three of you headed to food court together.) # bg:foodcourt # sprite:none
Honami: Oh my! # sprite:honami_shock
Honami: There's a lot of people here!
Rui: Yeah, especially there's more choices here. # left:rui_normal # right:honami_shock
Rui: Which at the same time, you could take as much as you want. # left:rui_smile # right:honami_normal
Honami: Yeah, so just a moderate portion will be nice. # left:rui_smile # right:honami_smile
Narrator: (Three of you queuing up together.) # sprite:none
Narrator: (Since there's too many people here, you started to feel growling in your stomach.) (-5 fullness)
~ fullness -= 5
Honami: *Taking rice, vegetables and meat in a small portion.* # sprite: honami_normal
Rui: *Not taking any vegetables, but moderate rice and meat.* # sprite: rui_smug
You: Hmm... # sprite:none
You: I am starving now...
You: What should I pick?

-> food_select
    
=== food_select ===
Menu: Balanced: Vegetables, chicken breast, small portion of rice.[NL] Large: More vegetables, chicken drumstick, large portion of rice.[NL]Extra Large: Huge portion of vegetables, L shaped chicken drumstick, 2 large portion of rice.
+ [Balanced meal (RM15, +35 fullness)]
    {
    - money >=15 :
        ~ money -= 15
        You: Good! I choose you!
        ~ mealselected = "fc_balance"
        ~ fullness += 35
        -> foodcourt_food
    
    - else:
        You: I only have {money} left...
        You: Let's pick something else...
        -> food_select
    }
    
+ [Large portion (RM25, +50 fullness)]
    {
    - money >=25 :
        ~ money -= 25
        You: I am really hungry.
        ~ mealselected = "fc_large"
        ~ fullness += 50
        -> foodcourt_food
    
    - else:
        You: I only have {money} left...
        You: Let's pick something else...
        -> food_select
    }
    
+ [EXTRA LARGE PORTION (RM30, +70 fullness)]
    {
    - money >=30 :
        ~ money -= 30
        You: Haha! Extra portion for extra happiness!
        ~ mealselected = "fc_xlarge"
        ~ fullness += 70
        -> foodcourt_food
    
    - else:
        You: I only have {money} left...
        You: Let's pick something else...
        -> food_select
    }
=== foodcourt_food ===
You: Alright! I am done for now!
Honami: You done? Let's go sit at the corner seat! # sprite:honami_smile
Rui: Fufu~ # sprite:rui_smug

Narrator: (Three of you sitted at the corner seat together, which Honami sits beside you.) # sprite:none
Honami: Alright, here we go. # sprite:honami_normal
    {
    - mealselected == "fc_balance":
        Honami: Oh! You picked fairly well! # left:rui_normal # right:honami_shock
        Honami: I am really happy for you.  # right:honami_smile
        Rui: I mean, it looks really well balanced. # sprite:rui_normal
        Rui: Unlike me... who discard every existance of any vegetables... # sprite:rui_smug
        Honami: *giggles* But you are still 182cm tall! # left:rui_smug # right:honami_smile
        Narrator: (You look at them teasing each other.)
        You: Well... let me start eating then.
        # sprite:none
        -> chitchat
    
    
    
    - mealselected == "fc_large":
        Honami: Oh my... are you starving? # sprite:honami_shock
        Honami: That amount is... #left:rui_normal # right:honami_shock
        Rui: It's fine, no worries. # sprite:rui_smile
        Rui: Especially our little friend is having a though morning just now.
        Rui: Enjoy your meal! # sprite:rui_smug
        -> chitchat
    
    
    - else:
        Honami & Rui: ...!? # left:rui_shock # right:honami_shock
        Honami: Erm...
        Rui: ...interesting. # left:rui_smug
        Rui: Seems like you're really trying to have a good time for now. Aren't you? 
        Honami: Yeah... I guess so... # right:honami_listening
        Honami: It's fine! Enjoy your meal! # sprite:honami_smile
        -> chitchat
    }





=== fastfood ===
Narrator: (A while later, three of you headed to fast food chain nearby together.) # bg:fastfood # sprite:none
Rui: Hmm... # sprite:rui_normal
Rui: As usual, there aren't many people in this time.
Honami: Yeah, it’s unlike the foodcourt. # left:rui_normal # right:honami_normal
Honami: There usually full of people queuing up for food.
Rui: Fufu~ Let’s order, shall we? # left:rui_smile
Honami: Sure! # right:honami_smile

Narrator: (Three of you standing in front of the kiosk.) # sprite:none

Rui: I will pick a simple set of burger, with sundae as side… # sprite:rui_smug
Honami: Well… I would like ala carte a burger with less sauces. # sprite:honami_listening
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
You: And... drink!
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
    You: Phew, I got enough money!
    You: Well... let's enjoy!
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
    Honami: Although it's not the best, but it's still good enough!
    Honami: Now let's go find a place to sit!
    -> chitchat
    
    - meal_points == 4:
    Honami: Well... it's understandable. # sprite:honami_normal
    Rui: Fufu~ It's fine for me! # left:rui_smile # right:honami_normal
    Rui: Especially I added on a sundae, so you're not the worst. 
    Honami: ... # sprite:honami_normal
    Honami: Now let's go find a place to sit! # sprite:honami_smile
    -> chitchat
    
    - meal_points == 5:
    Honami & Rui: ...!? # left:rui_shock # right:honami_shock
    Honami: Erm...
    Rui: ...interesting. # left:rui_smug
    Rui: Seems like you're really trying to have a good time for now. Aren't you? 
    Honami: Yeah... I guess so... # right:honami_listening
    Honami: It's fine! Now let's go find a place to sit! # sprite:honami_smile
    -> chitchat
    
    - meal_points == 6:
    Honami & Rui: ...!? # left:rui_shock # right:honami_shock
    Honami: Oh my...
    Rui: ...interesting. # sprite:rui_smug
    Rui: Seems like you're really trying to have a good time for now. Aren't you? # sprite:rui_smile
    Rui: But even I didn't expect that you... enjoy high calorie food than me. # sprite:rui_smug
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
Narrator: Demo End.
Narrator: Send this stat to Yuri. [NL] First pick: {firstpick} Location: {location} Point: {meal_points} Food: {mealselected}
-> END