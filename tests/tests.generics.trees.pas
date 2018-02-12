{
    This file is part of the Free Pascal run time library.
    Copyright (c) 2018 by Maciej Izak (hnb),
    member of the Free Pascal development team

    It contains tests for the Free Pascal generics library

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

    Acknowledgment

    Thanks to Sphere 10 Software (http://sphere10.com) for sponsoring
    many new types, tests and major refactoring of entire library

 **********************************************************************}

unit tests.generics.trees;

{$mode delphi}

interface

uses
  fpcunit, testregistry, testutils, tests.generics.utils,
  Classes, SysUtils, Generics.Collections;

type

  { TTestArrayHelper }

  { TTestTrees }

  TTestTrees = class(TTestCollections)
  published
    procedure Test_IndexedAVLTree_Add_General;
    procedure Test_IndexedAVLTree_Add;
    procedure Test_IndexedAVLTree_Delete;

    procedure Test_TAVLTreeMap_Notification;
    procedure Test_TIndexedAVLTreeMap_Notification;
    procedure Test_TAVLTree_Notification;
    procedure Test_TIndexedAVLTree_Notification;
  end;

implementation

type
  TStringsTree = TIndexedAVLTree<string>;

{ TTestTrees }

procedure TTestTrees.Test_IndexedAVLTree_Add_General;
const
  _COUNT = 999;
var
  LNumbers: THashSet<Integer>;
  i, j: Integer;
  LTree: TStringsTree;
  LNodes: TList<TStringsTree.PNode>;
  n: TStringsTree.PNode;
begin
  LNumbers := THashSet<Integer>.Create;
  LTree := TStringsTree.Create;
  LNodes := TList<TStringsTree.PNode>.Create;

  try
    // check consistency of adding new nodes to Indexed AVL
    for i := 0 to _COUNT do
    begin
      LNodes.Add(LTree.Add('0'+i.ToString));
      LNumbers.Clear;
      for n in LTree.Nodes do
        Check(LNumbers.Add(LTree.NodeToIndex(n)), 'Wrong index (duplicate) of '+ i.ToString + ' for node ' + n.Key);
      for j := 0 to LNodes.Count - 1 do
        Check(LNumbers.Contains(j), 'Missing index ' + j.ToString + ' for i = ' + i.ToString);
      LTree.ConsistencyCheck;
      CheckEquals(i+1, LTree.Count, 'Wrong tree count');
    end;
  finally
    LNodes.Free;
    LTree.Free;
    LNumbers.Free;
  end;
end;

procedure TTestTrees.Test_IndexedAVLTree_Add;
var
  LTree: TStringsTree;
begin
  LTree := TStringsTree.Create;

  try
    LTree.Duplicates:=dupAccept;
    LTree.Add('Aaa');
  finally
    LTree.Free;
  end;
end;

procedure TTestTrees.Test_IndexedAVLTree_Delete;
const
  _COUNT = 999;
var
  LNumbers: THashSet<Integer>;
  i, j: Integer;
  LTree: TStringsTree;
  LNodes: TList<TStringsTree.PNode>;
  n: TStringsTree.PNode;
begin
  LNumbers := THashSet<Integer>.Create;
  LTree := TStringsTree.Create;
  LNodes := TList<TStringsTree.PNode>.Create;

  try
    for i := 0 to _COUNT do
      LNodes.Add(LTree.Add('0'+i.ToString));

    // check consistency of deleting nodes from Indexed AVL
    for i := 0 to _COUNT do
    begin
      LTree.Delete(LNodes.ExtractIndex(Random(LNodes.count)));
      LNumbers.Clear;
      for n in LTree.Nodes do
        Check(LNumbers.Add(LTree.NodeToIndex(n)), 'Wrong index (duplicate) of '+ i.ToString + ' for node ' + n.Key);
      for j := 0 to LNodes.Count - 1 do
        Check(LNumbers.Contains(j), 'Missing index ' + j.ToString + ' for i = ' + i.ToString);
      LTree.ConsistencyCheck;
      CheckEquals(_COUNT-i, LTree.Count, 'Wrong tree count');
    end;
  finally
    LNodes.Free;
    LTree.Free;
    LNumbers.Free;
  end;
end;

procedure TTestTrees.Test_TAVLTreeMap_Notification;
begin

end;

procedure TTestTrees.Test_TIndexedAVLTreeMap_Notification;
begin

end;

procedure TTestTrees.Test_TAVLTree_Notification;
begin

end;

procedure TTestTrees.Test_TIndexedAVLTree_Notification;
begin

end;

begin
  RegisterTest(TTestTrees);
end.

