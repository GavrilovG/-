{$apptype windows}
//Гаврилов Григорий 24.10.20
uses 
  Microsoft.SmallBasic.Library, System, System.Windows.Forms, System.Threading;

const
  width = 31;
  height = 22;
  size_rectangle = 20;

var
  f: system.Windows.forms.form;
  btn: system.Windows.forms.button;
  time, score, dir: integer;
  game: array[1..height] of array[1..width] of integer;
  //тело змейки
  path: array[1..600] of integer;
  snake: integer;
  a, b: integer;
  game2: array[1..height] of array[1..width] of integer;


procedure addPath(dir: integer; length: integer);
begin
  for var i := length downto 2 do
    path[i] := path[i - 1];
  if dir = 1 then
    path[1] := 3;
  if dir = 2 then
    path[1] := 4;
  if dir = 3 then
    path[1] := 1;
  if dir = 4 then
    path[1] := 2;
end;


{procedure Draw_Rectangle();
begin
  GraphicsWindow.GetColorFromRGB(0, 0, 0);
  GraphicsWindow.FillRectangle(10, 10, size_rectangle * width, size_rectangle * height);
end;}
procedure getTail(var x: integer; var y: integer);//tail from head
begin
  for var i := 1 to snake - 1 do
  begin
    if path[i] = 3 then
      x := x - 1;
    if path[i] = 1 then
      x := x + 1;
    if path[i] = 2 then
      y := y - 1;
    if path[i] = 4 then
      y := y + 1;
  end;
end;
  

procedure Draw_Field();
begin
  
  GraphicsWindow.DrawLine(0, 0, width * size_rectangle, 0);
  GraphicsWindow.DrawLine(0, 0, 0, height * size_rectangle);
  GraphicsWindow.DrawLine(width * size_rectangle, 0, width * size_rectangle, height * size_rectangle);
  GraphicsWindow.DrawLine(0, height * size_rectangle, width * size_rectangle, height * size_rectangle);
  for var i := 1 to width do
    GraphicsWindow.DrawLine(i * size_rectangle, 0, i * size_rectangle, height * size_rectangle);
  for var i := 1 to height do
    GraphicsWindow.DrawLine(0, i * size_rectangle, width * size_rectangle, i * size_rectangle);
end;

procedure DrawCell();
begin

  for var i := 1 to height do
  begin
    for var j := 1 to width do
    begin
      if (game[i][j] = 1) then 
      begin
        GraphicsWindow.BrushColor := GraphicsWindow.GetColorFromRGB(255, 215, 0);//0, 255, 0
        GraphicsWindow.FillRectangle((j - 1)  * size_rectangle + 1, (i - 1) * size_rectangle + 1, size_rectangle - 2, size_rectangle - 2);
      end
      else if (game[i][j] = 2) then
      begin
        GraphicsWindow.BrushColor := GraphicsWindow.GetColorFromRGB(255, 0, 0);
        GraphicsWindow.FillRectangle((j - 1) * size_rectangle + 1, (i - 1) * size_rectangle + 1, size_rectangle - 2, size_rectangle - 2);
      end
      else if (game[i][j] = 0) then
      begin
        GraphicsWindow.BrushColor := GraphicsWindow.GetColorFromRGB(255, 255, 255);
        GraphicsWindow.FillRectangle((j - 1) * size_rectangle + 1, (i - 1) * size_rectangle + 1, size_rectangle - 2, size_rectangle - 2);
      end;
    end;
  end;
  
end;

function sum_of_neighbour(x, y: integer): integer;
var
  xc, yc, neighbours: integer;
begin
  neighbours := 0;
  for var i := -1 to 1 do
    for var j := -1 to 1 do
    begin
      if((i <> 0) or (j <> 0)) then
      begin
        xc := x + i;
        yc := y + j;
        if xc = 0 then
          xc := height;
        if xc = height + 1 then
          xc := 1;
        if yc = 0 then
          yc := width;
        if yc = width + 1 then
          yc := 1;
        if(game[xc][yc] = 2) then
          neighbours += 1;
      end;
    end;
  result := neighbours;
end;

procedure Live();
begin
  
  
  for var i := 1 to height do
  begin
    for var j := 1 to width do
    begin
      if (game[i][j] = 1) then
        game2[i][j] := 1;
      if (game[i][j] = 0) then
      begin
        if (sum_of_neighbour(i, j) = 3) then
          game2[i][j] := 2
        else
          game2[i][j] := 0;
      end;
      if (game[i][j] = 2) then
      begin
        if not ((sum_of_neighbour(i, j) = 2) or (sum_of_neighbour(i, j) = 3)) then
          game2[i][j] := 0
        else
          game2[i][j] := 2;
      end;
      
    end;
    
  end;
  for var n := 1 to height do
  begin
    for var m := 1 to width do
    begin
      game[n][m] := game2[n][m];
      
    end;
  end;
end;

procedure OnTimer();
{var
  xt, yt: integer;}
begin
  var xt := a;
  var yt := b;
  time += 1;
  var KeyPressed: string;
  KeyPressed := GraphicsWindow.LastKey;
  GraphicsWindow.Title := string.concat('Твой счет: ', score);
    // 1 вниз 2 влево 3 вверх 4 вправо
  dir := 0;
  if KeyPressed = 'D' then
    dir := 4;
  if KeyPressed = 'S' then
    dir := 1;
  if KeyPressed = 'A' then
    dir := 2;
  if KeyPressed = 'W' then
    dir := 3;
  if dir = 3 then
  begin
    if (a = 1) or (game[a - 1][b] = 1) then
    begin
      Timer.Interval := 1000000000
    end 
    else
    begin
      getTail(xt, yt);
      game[xt][yt] := 0;
      
      if game[a - 1][b] = 2 then
      begin
        score += 1;
        snake += 1;
      end;
      addPath(dir, snake - 1);
      game[a - 1][b] := 1;
      a := a - 1;
      
    end;
  end;
  if dir = 4 then 
  begin
    if (b > width - 1) or (game[a][b + 1] = 1) then
    begin
      Timer.Interval := 1000000000;
      
    end else 
    begin
      getTail(xt, yt);
      game[xt][yt] := 0;
      if game[a][b + 1] = 2 then
      begin
        score += 1;
        snake += 1;
        
      end;
      addPath(dir, snake - 1);
      game[a][b + 1] := 1;
      b := b + 1;
      
    end;
  end;
  
  if dir = 1 then
  begin
    if (a > height - 1) or (game[a + 1][b] = 1) then
    begin
      Timer.Interval := 1000000000;
      
    end else
    begin
      getTail(xt, yt);
      game[xt][yt] := 0;
      
      if game[a + 1][b] = 2 then
      begin
        score += 1;
        snake += 1;
      end;
      addPath(dir, snake - 1);
      game[a + 1][b] := 1;
      a := a + 1;
      
    end;
  end;
  if dir = 2 then
  begin
    if (b = 1) or (game[a][b - 1] = 1) then
    begin
      Timer.Interval := 1000000000;
    end else
    begin
      
      getTail(xt, yt);
      game[xt][yt] := 0;
      
      if game[a][b - 1] = 2 then 
      begin
        score += 1;
        snake += 1;
        
      end;
      addPath(dir, snake - 1);
      game[a][b - 1] := 1;
      b := b - 1;
      
    end;
  end;
  //Draw_Rectangle();
  Live();
  DrawCell();
  //Timer.Interval := 500;
end;




procedure InitField();

begin
  a := PABCSystem.Random(1, height);
  b := PABCSystem.Random(1, width);
    // food in random cells
    // snake in random cells
  for var i := 1 to 100 do
    game[PABCSystem.Random(1, height)][PABCSystem.Random(1, width)] := 2; 
  for var i := 1 to height do
  begin
    for var j := 1 to width  do
      GraphicsWindow.DrawText((j - 1) * size_rectangle, (i - 1) * size_rectangle, sum_of_neighbour(i, j));
    sleep(20);
  end;
  game[a][b] := 1;
  
  Timer.Interval := 200;
  Timer.Tick += OnTimer;
  
end;

procedure buttonClick(sender: object; e: eventargs);
begin
  btn.height := 0;
  btn.width := 0;
  Draw_Field();
  InitField;
end;

begin
  time := 0;
  score := 0;
  snake := 1;
  dir := 0;
  f := new form;
  f.text := 'qwerty';
  f.height := 480;
  f.width := 640;
  
  btn := new button;
  btn.height := 35;
  btn.width := 120;
  btn.text := 'начать игру';
  btn.left := 20;
  btn.top := 20;
  btn.Click += buttonClick;
  f.controls.add(btn);
  application.run(f);
end.
