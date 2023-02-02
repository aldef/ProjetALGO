unit Unit2;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Math;

type
  TPiece = class
  private
    FX, FY: Integer;
    FBlanche: Boolean;
    FSymbole: String;
  public
    property X: Integer read FX write FX;
    property Y: Integer read FY write FY;
    property estBlanche: Boolean read FBlanche write FBlanche;
    property Symbole: String read FSymbole write FSymbole;
    function PeutAllerEn(Xdest, Ydest: Integer): Boolean; virtual; abstract;
    constructor Create(Xvar : Integer; Yvar: Integer; estBlancheVar: Boolean);
  end;

  TPion = class(TPiece)
  public
    function PeutAllerEn(Xdest, Ydest: Integer): Boolean; override;
    constructor Create(Xvar : Integer; Yvar: Integer; estBlancheVar: Boolean);
  end;

  TTour = class(TPiece)
  public
    function PeutAllerEn(Xdest, Ydest: Integer): Boolean; override;
    constructor Create(Xvar : Integer; Yvar: Integer; estBlancheVar: Boolean);
  end;

  TCavalier = class(TPiece)
  public
    function PeutAllerEn(Xdest, Ydest: Integer): Boolean; override;
    constructor Create(Xvar : Integer; Yvar: Integer; estBlancheVar: Boolean);
  end;

  TFou = class(TPiece)
  public
    function PeutAllerEn(Xdest, Ydest: Integer): Boolean; override;
    constructor Create(Xvar : Integer; Yvar: Integer; estBlancheVar: Boolean);
  end;

  TReine = class(TPiece)
  public
    function PeutAllerEn(Xdest, Ydest: Integer): Boolean; override;
    constructor Create(Xvar : Integer; Yvar: Integer; estBlancheVar: Boolean);
  end;

  TRoi = class(TPiece)
  public
    function PeutAllerEn(Xdest, Ydest: Integer): Boolean; override;
    constructor Create(Xvar : Integer; Yvar: Integer; estBlancheVar: Boolean);
  end;

var
    Plateau: array[0..7, 0..7] of TPiece;
    RegistreCoupsPossibles: string;
    OrientationPlateau: boolean;

implementation

constructor TPiece.Create(Xvar : Integer; Yvar: Integer; estBlancheVar: Boolean);
begin
  FX := Xvar;
  FY := Yvar;
  FBlanche := estBlancheVar;
  FSymbole := '';
end;

constructor TPion.Create(Xvar : Integer; Yvar: Integer; estBlancheVar: Boolean);
begin
  inherited Create(Xvar, Yvar, estBlancheVar);
  FSymbole := '♟';
end;

constructor TTour.Create(Xvar : Integer; Yvar: Integer; estBlancheVar: Boolean);
begin
   inherited Create(Xvar, Yvar, estBlancheVar);
   FSymbole := '♜';
end;

constructor TCavalier.Create(Xvar : Integer; Yvar: Integer; estBlancheVar: Boolean);
begin
   inherited Create(Xvar, Yvar, estBlancheVar);
   FSymbole := '♞';
end;

constructor TFou.Create(Xvar : Integer; Yvar: Integer; estBlancheVar: Boolean);
begin
   inherited Create(Xvar, Yvar, estBlancheVar);
   FSymbole := '♝';
end;

constructor TReine.Create(Xvar : Integer; Yvar: Integer; estBlancheVar: Boolean);
begin
   inherited Create(Xvar, Yvar, estBlancheVar);
   FSymbole := '♛';
end;

constructor TRoi.Create(Xvar : Integer; Yvar: Integer; estBlancheVar: Boolean);
begin
   inherited Create(Xvar, Yvar, estBlancheVar);
   FSymbole := '♚';
end;

function TPion.PeutAllerEn(Xdest, Ydest: Integer): Boolean;
begin
   //si la pièce est noire ou blanche et qu'elle est en bas de l'échiquier
   if (OrientationPlateau and not Self.estBlanche) or (not OrientationPlateau and Self.estBlanche) then
   begin
      if (Ydest = Self.Y) and (Self.X = Xdest + 1) then
      begin
         if (Plateau[Xdest,Ydest] = nil) or (Plateau[Xdest,Ydest].estBlanche <> Self.estBlanche) then
            Result := True
         else
            Result := False
      end
      else
         Result := False;
   end;

   //si la pièce est noire ou blanche et qu'elle est en haut de l'échiquier
   if (not OrientationPlateau and not Self.estBlanche) or (OrientationPlateau and Self.estBlanche) then
   begin
      if (Ydest = Self.Y) and (Xdest = Self.X + 1) then
      begin
         if (Plateau[Xdest,Ydest] = nil) or (Plateau[Xdest,Ydest].estBlanche <> Self.estBlanche) then
            Result := True
         else
            Result := False
      end
      else
         Result := False;
   end;
end;

//Les algorithmes de TTour.PeutAllerEn() et TFou.PeutAllerEn() sont séparés dans deux autres fonctions
//Afin de pouvoir les réutiliser pour TReine
function TourPeutAllerEn(Xsrc, Ysrc, Xdest, Ydest: Integer): Boolean;
var
  i: Integer;
begin
  if (Xdest = Xsrc) or (Ydest = Ysrc) then
  begin
    //Si le déplacement de la tour est sur l'axe horizontal
    if Xdest = Xsrc then
    begin
      //Si la destination se trouve au dessus
      if Ydest > Ysrc then
      begin
        for i := Ysrc + 1 to Ydest - 1 do
          if Plateau[Xsrc, i] <> nil then
          begin
            Result := False;
            Exit;
          end;
      end
      else
      //Si la destination se trouve au dessous
      begin
        for i := Ydest + 1 to Ysrc - 1 do
          if Plateau[Xsrc, i] <> nil then
          begin
            Result := False;
            Exit;
          end;
      end;
    end
    else
    //Si le déplacement de la tour est sur l'axe vertical
    begin
      //Si la destination se trouve à droite
      if Xdest > Xsrc then
      begin
        for i := Xsrc + 1 to Xdest - 1 do
          if Plateau[i, Ysrc] <> nil then
          begin
            Result := False;
            Exit;
          end;
      end
      else
      //Si la destination se trouve à gauche
      begin
        for i := Xdest + 1 to Xsrc - 1 do
          if Plateau[i, Ysrc] <> nil then
          begin
            Result := False;
            Exit;
          end;
      end;
    end;

    //Enfin, vérifier si la pièce de destination n'est pas une pièce de la même couleur
    if (Plateau[Xdest,Ydest] <> nil) and (Plateau[Xdest,Ydest].estBlanche = Plateau[Xsrc,Ysrc].estBlanche) then
      Result := False
    else
      Result := True;
  end
  else
    Result := False;
end;

function FouPeutAllerEn(Xsrc, Ysrc, Xdest, Ydest: Integer): Boolean;
var
  i: Integer;
  Xinc, Yinc: Integer;
begin
  Result := False;
  if Abs(Xsrc - Xdest) = Abs(Ysrc - Ydest) then
  begin
    Xinc := Sign(Xdest - Xsrc);
    Yinc := Sign(Ydest - Ysrc);
    for i := 1 to Abs(Xsrc - Xdest) - 1 do
      if Plateau[Xsrc + i * Xinc, Ysrc + i * Yinc] <> nil then
        Exit;
    if (Plateau[Xdest,Ydest] = nil) or (Plateau[Xdest,Ydest].estBlanche <> Plateau[Xsrc,Ysrc].estBlanche)
then
Result := True;
end;
end;

function TTour.PeutAllerEn(Xdest, Ydest: Integer): Boolean;
begin
   if TourPeutAllerEn(Self.X, Self.Y, Xdest, Ydest) then
       Result := True
   else
       Result := False;
end;

function TFou.PeutAllerEn(Xdest, Ydest: Integer): Boolean;
begin
   if FouPeutAllerEn(Self.X, Self.Y, Xdest, Ydest) then
       Result := True
   else
       Result := False;
end;

function TReine.PeutAllerEn(Xdest, Ydest: Integer): Boolean;
begin
   if FouPeutAllerEn(Self.X, Self.Y, Xdest, Ydest) or TourPeutAllerEn(Self.X, Self.Y, Xdest, Ydest) then
      Result := True
   else
      Result := False;
end;

function TCavalier.PeutAllerEn(Xdest, Ydest: Integer): Boolean;
begin
   if ((Abs(Xdest - Self.X) = 2) and (Abs(Ydest - Self.Y) = 1)) or ((Abs(Xdest - Self.X) = 1) and (Abs(Ydest - Self.Y) = 2)) then
   begin
      if (Plateau[Xdest,Ydest] = nil) or (Plateau[Xdest,Ydest].estBlanche <> Self.estBlanche) then
         Result := True
   end
   else
     Result := False;
end;

function TRoi.PeutAllerEn(Xdest, Ydest: Integer): Boolean;
begin
   if ((Abs(Xdest - Self.X) <= 1) and (Abs(Ydest - Self.Y) <= 1)) and ((Plateau[Xdest,Ydest] = nil) or (Plateau[Xdest,Ydest].estBlanche <> Self.estBlanche)) then
      Result := True
   else
      Result := False;
end;

end.

