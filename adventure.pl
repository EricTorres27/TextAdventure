
:- dynamic item_on/2, position/1, alive/1.   /* Needed by SWI-Prolog. */
:- retractall(item_on(_, _)), retractall(position(_)), retractall(alive(_)).

/*Start in the spawn*/
position(monastery).

/* This fact specifies that the cult is alive. */

alive(cult).

/* This define the world and the conections */

/* Monastery*/
path(monastery,south,forest).
path(monastery,west,river).
path(monastery,east,town).

/*River*/
path(river,east,monastery).
path(river,south,castle_entrance):-
  write('You are trap by the strong current, you were always an amazing heroic fighter but not a good swimmer, you drown in your own shame.'), nl,
  !, die.
/*Forest*/
path(forest,north,monastery).
path(forest,south,cottage).
path(forest,east,cave_entrance).

/*Cottage*/
path(cottage,north,forest).
path(cottage,up,atic).
path(cottage,south,meadow).

/*Cottage atic*/
path(atic,down,cottage).

/* Cave entrance*/
path(cave_entrance,east,cave):- 
  item_on(lantern, in_hand).
path(cave_entrance,east,cave):- 
  write('It is to dark to move foward'), nl,
        !, fail.
path(cave_entrance,west,forest).

/*Cave*/
path(cave,west,cave_entrance).
path(cave,east,cave_doors).

/* Cave doors*/
path(cave_doors,south,innocence):-
  write('The door opens and you go inside, as you go deeper into the empty room you start to hear something.'), nl,
  write('When you turn around you see how the door closes behind you, you try to open it but it wont move.'), nl,
  write('Youre trap, as you wait until someone comes to rescue you the only thing you can hear are the walls speaking to you.'), nl,
  write('All they say is: innocence, innocence, innocence...'), nl,
  !, die.

path(cave_doors,east,night):-
  write('Nothing seems to happend as you come close to the door, you try to open it by pushin it but it wont move.'), nl,
  write('As you go back you start to feel dizzy you face down only to see your hands cover in a dark color '), nl,
  write('You start to feel cold, you fall to your knees and for a moment, as you close your you can only hear a voice telling you:'), nl,
  write('You can go to sleep in the eternal night heretic..'), nl,
  !, die.

path(cave_doors,north,silence).
path(cave_doors,west,cave).
/* Silence*/
path(silence,south,cave_doors).
/*Town*/
path(town,west,monastery).
path(town,south,road).
path(town,east,armery):-
   item_on(key, in_hand).
path(town,east,armery):- 
  write('The door is locked you cannot enter'), nl,
        !, fail.
path(town,north,corpses).

/*Town armery*/
path(armery,west,town).
/*Town corpses*/
path(corpses,south,town).
/*Road to castle*/
path(road,north,town).
path(road,south,cult).

/*Cult*/
path(cult,west,castle_entrance):-
  alive(cult),
  write(' The cultists dont let you pass, you will need to fint another way!'), nl,
  !,fail.
path(cult,west,castle_entrance).
path(cult,north,road).

/*Meadow*/
path(meadow,south,castle_entrance).
path(meadow,north,cottage).

/*Castle entrance*/
path(castle_entrance,south,castle).
path(castle_entrance,north,meadow).
path(castle_entrance,east,cult).

/* Assign items to the locations */

item_on(riddle, cave).
item_on(letter, silence).
item_on(key, corpses).
item_on(lantern, atic).
item_on(sword, armery).
item_on(shield, armery).
item_on(ropes,cult).


/* Learn about the items you have*/
info(riddle):-
  item_on(X, in_hand),
  write('This piece of papper seems odd, it only has three phrases on it:'),nl,
  write('Say my name and i shall disapear'),nl,
  write('You can break me easily without even touching me or seeing me.'),nl,
  write('Im so delicate that even the squeak of a mouse can kill me.'),nl.
info(shield):-
  item_on(X, in_hand),
  write('A round wooden shield, to protect you and others.'),nl.
info(letter):-
  item_on(X, in_hand),
  write('This letter belongs to the witch cult, a hierarch, it explains the attack to the monastery as well as the attack to a nearby village.'),nl.
info(key):-
  item_on(X, in_hand),
  write('This key is cover in blood, it may open a door of the town it was found.'),nl.
info(lantern):-
  item_on(X, in_hand),
  write('An old lantern with a little left of oil, it can help to see in the dark.'),nl.
info(sword):-
  item_on(X, in_hand),
  write('A long sharp sword, made for killing, or maybe to protect?.'),nl.
info(ropes):-
  item_on(X, in_hand),
  write('Ropes of the witch cult, they are still warm, for the blood spilled in them from the owner, or from it victims...'),nl.
info(_) :-
        write('I don'' have nothing like that with me'),
        nl.
/* These rules describe how to pick up an object. */

take(X) :-
        item_on(X, in_hand),
        write('You''have this item already'),
        nl, !.

take(X) :-
        position(Place),
        item_on(X, Place),
        retract(item_on(X, Place)),
        assert(item_on(X, in_hand)),
        write('OK.'),
        nl, !.
take(_):-
        write('I don''t see nothing here to grab.'),
        nl.


/* These rules tell how to handle killing the lion and the spider. */

attack :-
        position(cult),
        item_on(sword, in_hand),
        retract(alive(cult)),
        write('You use the sword to beat the cultists and avenge the village and you brothes of the monastery'), nl,
        nl, !.

attack :-
        position(cult),
        write('You run directly into the cultist with heroic rage in your bare fist, the cultist stab you multiple times and you died'), nl,
        !, die.
attack :-
        position(castle_entrance),
        write('The royal guards are not an easy oponent, the take you down and put you in a dungeon'), nl,
        !, die.
attack :-
        write('Nothing to attack over here.'), nl.

/* Talk */
talk :-
        item_on(ropes, in_hand),
          write('The guards see the ropes of the cult and belive you; the doors start to open, you may proceed to see the king!'),nl,
          write('You are in front of the king and start to explain the situation to him, you did it, thanks to you there may still be hope to stop the witch cult'),nl,
          exit, !.
talk :-
        item_on(letter, in_hand),
         write('The guards read the letter of the cult and belive you; the doors start to open, you may proceed to see the king!'),nl,
         write('You are in front of the king and start to explain the situation to him, you did it, thanks to you there may still be hope to stop the witch cult'),nl,
         exit, !.
talk :-
        position(castle_entrance),
        write('The guards in the entrance of the castle stop you, you try to explain the urge to see the king buy they dont buy it, maybe somekind of proof could make them change opinion'), nl,
        !, fail.
talk :-
        write('There is no one to talk over here.'), nl.

/* This rule tells how to die. */

die :-
        !,
        write('YOU DIED'),
        halt.

/*End the game*/
exit :-
        nl,
        write('GAME OVER'),
        nl,
        halt.

/* These rules define the six direction. */

north :- move(north).
south :- move(south).
east :- move(east).
west :- move(west).
up :- move(up).
down :- move(down).

/* This rule tells how to move in a given direction. */

move(Direction) :-
        position(Here),
        path(Here, Direction, There),
        retract(position(Here)),
        assert(position(There)),
        position(Place),
        scene(Place), !.
move(_) :-
        write('You can''t go that way.').


/* This rule tells how to look about you. */

look :-
        position(Place),
        nl,
        search_objects(Place),
        nl.


/* These rules set up a loop to mention all the objects
   in your vicinity. */

search_objects(Place) :-
        item_on(X, Place),
        write('There is a '), write(X), write(' here.'), nl,
        fail.

search_objects(_).

/* Define the scenes and describe the enviroment*/
scene(monastery) :-
  write('You see the outside of the monastery it is destoyed to the goround it was a miracle that you suriveve.'), nl,
  write('There is a river to the West, a forest to the South and a road that lead to a village in the East'), nl.

scene(river) :-
  write('You come across a long river, you can berealy see the other side of it, it is to deep and the current seems strong.'), nl,
  write('You can attempt to cross it straight by going to the south, or you can go back to the monastery by going east'), nl.

scene(forest):-
  write('You are now deep in the forest, the trees are so tall that you can barely see the sunlight,'), nl,
  write('there is nothing more to see than vegetetion except one road to the south, your footprings'), nl, 
  write('to the north that leade to the monastery and some footpring that you are not able to recognize that go deeper into the forest in the east.'),nl.

scene(cave_entrance):-
  write('You are in the mouth of a cave. The exit is to the west but it seems something is inside this cave to the east'), nl.

scene(cave):-
  write('As you enter the cave you see an tables, maps, weapons, it seems like an outpost but for who?'),nl,
  write('This doubt clears as you see the emblem of the witch cult in a flag, you may want to check around to see if you find something important.'),nl,
  write('There are three doors tham seem kind of strange to the east. You may wanht to be cautios'),nl.

scene(cave_doors):-
  write('As you aproach the doors you see the face of a skull in each one'),nl,
  write('The fisrt door to the south has an encription that says Innocence'),nl,
  write('The midle door to the east has an encription that says Night'),nl,
  write('The last door to the north has an encription that says Silence'),nl,
  write('What could be the meaning of this?'),nl.

scene(silence):-
  write('You enter a dark room more complex than the last one, in there you can find multiple books, maps, weapons and runes draw in the walls.'),nl,
  write('There is a big table surrounded by chairs, the one in the middle is bigger than the others.'),nl,
  write('Dont forget the witch cult is an organized cult maybe something important happened here.'),nl,
  write('The exit is to the south'),nl.

scene(cottage):-
  write('You enter a cottage that seems abandoned, there are some stairs that go up to an atic,'), nl,
  write('before entering you notice that there is a road that leads to the end of the forest to the south'),nl.

scene(atic):-
  write('You enter the an atic, there are plenty of items and boxes cover by dust.'), nl,
  write('Maybe you can find something.'),nl.

scene(meadow):-
  write('You find yourself now out of the forest, you can se the light reaching the meadows that extend to the horizon, on the far yo can see the castle of the king in the south.').

scene(town):-
  write('As you aproach the village your eyes can not belive what they are seeing, everything is burn to ashes, what was a lovely vigalle is now a graveyard. This also was made by the witch cult.'),nl,
  write('There is a road to exit the village in the south, you can also see that the only building left is the forge and there is something more, you can smell a putrid smell coming from the north.'),nl.

scene(corpses):-
  write('The smell takes you to a pile of burn bodies, the smell of dead is so strong that you can barely hold your stomach'),nl,
  write('You can go back to the cventer of the village by going to the south'),nl.

scene(armery):-
  write('There are some stuff insede the armery you shoul look if something is still in shape for you to use it, the exit is in the west'),nl,
  write('The exit is to the west.'),nl.

scene(road):-
  write('Behind you in the north you can see the smoke coming out of the village; This road that seems to lead to the south maybe it leads to the castle of the king'),nl.

scene(cult):-
  alive(cult),
  write('As you advance you start to hear screms, and all of the sudden you see them, is the witch cult! they took some villaggers prisioners.'),nl,
  write('There are two of them and another one dead in the ground, if you have something to fight you can easly defeat them or you can try to attack them with your bare hands and will power.'),nl,
  write('You can escape by returnning to the road in the norht or you can try to go to the castle in the west.'),nl.

scene(castle_entrance):-
      write('You are face to face with the guards of the door and they ask what are your intentios and who you are,'),nl, 
      write('maybe you could talk to them'),nl.

scene(died_scene):-
      write('scene just to die'),nl.

intro:-
  write('You wake up surroended by smoke and fire, the monastery is destoyed, all you can see is your fellow monks laying dead on the ground.'), nl,
  write('The last thing you rememeber are person wearing a purple tunic with a icon on the center that represent only one thing. The cult of the witch'), nl,
  write('You need to advise the others about the danger that is coming to the kingdome, you need to go see the king who lives in the south and tell him what you saw'), nl,
  write('That is our only hope'), nl.

instructions:-
        write('To enter this world you will have to write the next list of actions (Prolog sintax).'), nl,
        write('+ This are the actions that you can choose:'), nl,
        write('+ You will move through the world with the next direction comands          ---- north.  south.  east.  west.  up.  down.'), nl,
        write('+ You will be able to pick up objects that you find in teh world by typing ---- take(item).'), nl,
        write('+ Defend yourself from enemies if you have the something to do it.         ---- attack.'), nl,
        write('+ Talk with npcs around the world to acces places or know information.     ---- talk.'), nl,
        write('+ To describe again were you are.                                          ---- look.'), nl,
        write('+ Deploy information of the items.                                         ---- info(item).'), nl,
        write('+ Deploy this message again.                                               ---- instructions.'), nl,
        write('+ Exit the game and the program.                                           ---- exit.'), nl,
        nl.

start:-
  instructions,
  intro,
  scene(monastery).