PImage home;
PImage input_icon;
PImage heat_map_icon;
PImage bc;
PImage shoe_icon;

void home_setup(){

home = loadImage("image.jpeg");
input_icon = loadImage("input.png");
heat_map_icon = loadImage("heat_map.png");
shoe_icon = loadImage("shoe.png");
bc = loadImage("bc.png");
}

void input_icon(int x , int y){
image(bc,x-10,y-10,120,120);
image(input_icon,x+10,y+12,80,80);
}

void heat_map_icon(int x , int y){
image(bc,x-10,y-10,120,120);
image(heat_map_icon,x+10,y+12,80,80);
}

void shoe_icon(int x , int y){
image(bc,x-10,y-10,120,120);
image(shoe_icon,x+10,y+12,80,80);
}

void home_draw(){
  background(home);
  input_icon(110,height/3+50);
  heat_map_icon(350,height/3+50);
  shoe_icon(590, height/3+50);
  
}
