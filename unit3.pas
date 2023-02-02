//Contient les fonctions liées au placement aléatoire de pièces sur l'échiquier
unit Unit3;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Unit2;

procedure PlacerLesRois();
procedure PlacerDesPieces(pieces: PChar; sontDesPions: Boolean; sontDesPiecesBlanches: Boolean);

implementation

//Distinguer les rois des autres pièces permet de s'assurer que chaque joueur possède bien un roi
procedure PlacerLesRois();
var
   Ligne1, Ligne2, Colonne1, Colonne2: Integer;
begin
repeat
   Ligne1 := Random(8);
   Ligne2 := Random(8);
   Colonne1 := Random(8);
   Colonne2 := Random(8);
   if (Ligne1 <> Ligne2) and (Abs(Ligne1 - Ligne2) > 1) and (Abs(Colonne1 - Colonne2) > 1) then
   begin
      Plateau[Ligne1,Colonne1] := TRoi.Create(Ligne1,Colonne1,true);
      Plateau[Ligne2,Colonne2] := TRoi.Create(Ligne2,Colonne2,false);
      Exit;
   end;
   until False;
end;

//
procedure PlacerDesPieces(pieces: PChar; sontDesPions: Boolean; sontDesPiecesBlanches: Boolean);
var
   n, ligne, colonne: Integer;
   nombreAplacer: Integer;
begin
   nombreAplacer := Random(StrLen(pieces));
   for n := 0 to nombreAplacer - 1 do
   begin
   repeat
     ligne := Random(8);
     colonne := Random(8);
   until (Plateau[ligne, colonne] = nil) and ((not sontDesPions) or (ligne <> 7) and (ligne <> 0));

   case pieces[n] of
        'T': begin
            Plateau[ligne, colonne] := TTour.Create(ligne, colonne, sontDesPiecesBlanches);
        end;
        'C': begin
            Plateau[ligne, colonne] := TCavalier.Create(ligne, colonne, sontDesPiecesBlanches);
        end;
        'F': begin
            Plateau[ligne, colonne] := TFou.Create(ligne, colonne, sontDesPiecesBlanches);
        end;
        'R': begin
            Plateau[ligne, colonne] := TReine.Create(ligne, colonne, sontDesPiecesBlanches);
        end;
        else
            Plateau[ligne, colonne] := TPion.Create(ligne, colonne, sontDesPiecesBlanches);
        end;
   end;
   end;



end.

