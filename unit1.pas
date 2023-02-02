//Contient les fonctions liées à l'interface
unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, Types, LCLIntf,
  StdCtrls, Unit2, Unit3;

type

  { TForm1 }

  TForm1 = class(TForm)
    InitialiserPlateauAleatoireButton: TButton;
    Label1: TLabel;
    ReinitialiserPlateau: TButton;
    CoupsPossiblesMemo: TMemo;
    ReorienterPlateauBouton: TButton;
    GrilleDeJeu: TStringGrid;
    procedure FormShow(Sender: TObject);
    procedure GrilleDeJeuDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure GrilleDeJeuSelectCell(Sender: TObject; aCol, aRow: Integer;
      var CanSelect: Boolean);
    procedure ReinitialiserPlateauClick(Sender: TObject);
    procedure ReorienterPlateau(Sender: TObject);
    procedure InitialiserPlateauAleatoire(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }


//Procédure qui permet d'initialiser le tableau à deux dimensions comme un jeu d'échecs au tour 1
procedure InitialiserPlateau();
var
  i, j: Integer;
begin
  //(Ré)initialise le tableau
  for i := 0 to 7 do
    for j := 0 to 7 do
      Plateau[i,j] := nil;

  // Initialise les pièces blanches

  Plateau[0,0] := TTour.Create(0,0,true);
  Plateau[0,1] := TCavalier.Create(0,1,true);
  Plateau[0,2] := TFou.Create(0,2,true);
  Plateau[0,3] := TReine.Create(0,3,true);
  Plateau[0,4] := TRoi.Create(0,4,true);
  Plateau[0,5] := TFou.Create(0,5,true);
  Plateau[0,6] := TCavalier.Create(0,6,true);
  Plateau[0,7] := TTour.Create(0,7,true);

  for i := 0 to 7 do
    Plateau[1,i] := TPion.Create(1,i, true);

  //Initialise les pièces noires

  for i := 0 to 7 do
    Plateau[6,i] := TPion.Create(6,i, false);

  Plateau[7,0] := TTour.Create(7,0,false);
  Plateau[7,1] := TCavalier.Create(7,1,false);
  Plateau[7,2] := TFou.Create(7,2,false);
  Plateau[7,3] := TReine.Create(7,3,false);
  Plateau[7,4] := TRoi.Create(7,4,false);
  Plateau[7,5] := TFou.Create(7,5,false);
  Plateau[7,6] := TCavalier.Create(7,6,false);
  Plateau[7,7] := TTour.Create(7,7,false);

end;

//Procédure, appelée à l'affichage du formulaire, qui permet de redimensionner le TStringGrid aux dimensions de la fenêtre
//et d'initialiser le tableau à deux dimensions représentant l'échiquier
procedure TForm1.FormShow(Sender: TObject);
var
    tailleParDefautLigne: Integer;
    tailleParDefautColonne: Integer;
    Colonnes: Integer;
    Lignes: Integer;
    LargeurColonne: Integer;
    HauteurColonne: Integer;
begin
  //Permet de redimensionner la grille de jeu (TStringGrid) selon la taille de la fenêtre
  tailleParDefautColonne := 64;
  tailleParDefautLigne := 22;
  Colonnes := GrilleDeJeu.ClientWidth div tailleParDefautColonne;
  Lignes := GrilleDeJeu.ClientHeight div tailleParDefautLigne;
  if Colonnes >= GrilleDeJeu.ColCount then
  begin
   LargeurColonne := Round(GrilleDeJeu.ClientWidth / GrilleDeJeu.ColCount - 1);
   HauteurColonne := Round(GrilleDeJeu.ClientHeight / GrilleDeJeu.RowCount - 1);
  end
  else
  begin
    LargeurColonne := Round(GrilleDeJeu.ClientWidth / Colonnes - 1);
    HauteurColonne := Round(GrilleDeJeu.ClientHeight / Colonnes - 1);
  end;
  GrilleDeJeu.DefaultColWidth := LargeurColonne;
  GrilleDeJeu.DefaultRowHeight := HauteurColonne;

  //En profiter pour initialiser le tableau représentant les pièces
  InitialiserPlateau;
  OrientationPlateau := true;
end;

//Procédure, appelée à l'affichage de chaque cellule du TStringGrid, qui colorie l'échiquier et affiche chaque pièce
//dans sa case
procedure TForm1.GrilleDeJeuDrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
var
    Couleur: TColor;
    Police: TFont;
begin
  //Permet de colorier la grille comme un jeu d'échecs
  with TStringGrid(Sender) do
  begin
    if Pos(Format('(%d,%d)', [aRow, aCol]), RegistreCoupsPossibles) <> 0 then
    begin
       if Plateau[aRow, aCol] <> nil then
       begin
        Canvas.Brush.color := TColor(RGB(153,0,0));
        Canvas.FillRect(aRect);
       end
       else
       begin
          Canvas.Brush.color := TColor(RGB(0,153,0));
       Canvas.FillRect(aRect);
       end
    end
    else
    begin
    if ((aCol mod 2 <> 0) and (aRow mod 2 = 0)) or ((aCol mod 2 = 0) and (aRow mod 2 <> 0)) then
    begin
       //Colorier le damier
       Canvas.Brush.Color := TColor(RGB(102,53,9));
       Canvas.FillRect(aRect);
    end
    else
    begin
       //Colorier le damier
       Canvas.Brush.Color := TColor(RGB(222,220,182));
       Canvas.FillRect(aRect);
    end
    end;

    //Placer la pièce qu'il faut s'il y en a une
    if Plateau[aRow, aCol] <> nil then begin

       //La couleur de police de TStringGrid prends l'ascendant sur Canvas.Font.Color()
       //donc je dois créer une Police pour chaque Canvas et lui affecter
       Police := TFont.Create;
       Police.Assign(GrilleDeJeu.Font);

       if Plateau[aRow, aCol].estBlanche = true then begin
          Police.Color := clWhite;
       end
       else
       begin
          Police.Color := clBlack;
       end;

       Canvas.Font := Police;
       Police.Destroy;

       Canvas.TextOut(aRect.Left + 20, aRect.Top + 4, Plateau[aRow, aCol].Symbole);
    end;

    end;
    end;

//Procédure appelée lors du clic sur une cellule de la grille de jeu
procedure TForm1.GrilleDeJeuSelectCell(Sender: TObject; aCol, aRow: Integer;
  var CanSelect: Boolean);
var
    i, j: Integer;
begin
  if Plateau[aRow,aCol] <> nil then
  begin
   CoupsPossiblesMemo.Lines.Add(Format('%s[%d,%d] en %d, %d', [Plateau[aRow,aCol].ClassName, Plateau[aRow,aCol].X, Plateau[aRow,aCol].Y, aRow, aCol]));
   RegistreCoupsPossibles := '';

   for i := 0 to 7 do
   begin
     for j := 0 to 7 do
     begin
        if Plateau[aRow,aCol].peutAllerEn(i,j) then
        begin
           if Plateau[i,j] = nil then
            CoupsPossiblesMemo.Lines.Add(Format('Peut aller en %d, %d', [i, j]))
           else
            CoupsPossiblesMemo.Lines.Add(Format('Peut prendre %s en %d,%d', [Plateau[i,j].ClassName, i, j]));

            RegistreCoupsPossibles := RegistreCoupsPossibles + Format('(%d,%d)', [i, j]);
        end;
     end;
   end;
   CoupsPossiblesMemo.Lines.Add(sLineBreak);
   GrilleDeJeu.Repaint();
  end;


end;

//Procédure, appelée par un bouton, pour réinitialiser le plateau, comme s'il était au tour 1
procedure TForm1.ReinitialiserPlateauClick(Sender: TObject);
begin
   InitialiserPlateau;
   RegistreCoupsPossibles := '';
   GrilleDeJeu.Repaint;
end;

//Procédure, appelée par un bouton, pour retourner le plateau
procedure TForm1.ReorienterPlateau(Sender: TObject);
var
  i, j: Integer;
  PieceTemp: TPiece;
begin
  for i := 0 to 3 do
  begin
     for j := 0 to 7 do
     begin
        PieceTemp := Plateau[i, j];
        Plateau[i, j] := Plateau[7-i, 7-j];
        Plateau[7-i, 7-j] := PieceTemp;
   end;
   end;

   for i:= 0 to 7 do
   begin
     for j := 0 to 7 do
     begin
       if Plateau[i,j] <> nil then
       begin
        Plateau[i,j].X := i;
        Plateau[i,j].Y := j;
       end;
     end;
   end;

    RegistreCoupsPossibles := '';
    OrientationPlateau := not OrientationPlateau;
    GrilleDeJeu.Repaint;

end;

//Procédure, appelée par un bouton, pour initialiser un nouveau plateau avec des pièces aléatoires
procedure TForm1.InitialiserPlateauAleatoire(Sender: TObject);
var
  i, j: Integer;
begin
  //(Ré)initialise le tableau
  for i := 0 to 7 do
    for j := 0 to 7 do
      Plateau[i,j] := nil;

   //Place des pièces aléatoirement sur l'ensemble du plateau
   PlacerLesRois();
   PlacerDesPieces('PPPPPPPP',true,true);
   PlacerDesPieces('PPPPPPPP',true,false);
   PlacerDesPieces('TCFRFCT',false,true);
   PlacerDesPieces('TCFRFCT',false,false);

   RegistreCoupsPossibles := '';
   GrilleDeJeu.Repaint;
end;

end.

