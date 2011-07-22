unit uVfsFileSource;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uWFXModule,
  uFileSourceProperty, uFileSourceOperationTypes,
  uVirtualFileSource, uFileProperty, uFileSource,
  uFileSourceOperation, uFile;

type

  IVfsFileSource = interface(IVirtualFileSource)
    ['{87D0A3EF-C168-44C1-8B10-3AEC0753846A}']

    function GetWfxModuleList: TWFXModuleList;

    property VfsFileList: TWFXModuleList read GetWfxModuleList;
  end;

  { TVfsFileSource }

  TVfsFileSource = class(TVirtualFileSource, IVfsFileSource)
  private
    FWFXModuleList: TWFXModuleList;

    function GetWfxModuleList: TWFXModuleList;

  public
    constructor Create(aWFXModuleList: TWFXModuleList); reintroduce;
    destructor Destroy; override;

    // Retrieve operations permitted on the source.  = capabilities?
    function GetOperationsTypes: TFileSourceOperationTypes; override;

    // Retrieve some properties of the file source.
    function GetProperties: TFileSourceProperties; override;

    // These functions create an operation object specific to the file source.
    function CreateListOperation(TargetPath: String): TFileSourceOperation; override;
    function CreateExecuteOperation(var ExecutableFile: TFile; BasePath, Verb: String): TFileSourceOperation; override;

    property VfsFileList: TWFXModuleList read FWFXModuleList;

  end;

implementation

uses
  LCLProc, uVfsListOperation, uVfsExecuteOperation;

constructor TVfsFileSource.Create(aWFXModuleList: TWFXModuleList);
begin
  inherited Create;
  FWFXModuleList:= TWFXModuleList.Create;
  FWFXModuleList.Assign(aWFXModuleList);
end;

destructor TVfsFileSource.Destroy;
begin
  FreeThenNil(FWFXModuleList);
  inherited Destroy;
end;

function TVfsFileSource.GetOperationsTypes: TFileSourceOperationTypes;
begin
  Result := [fsoList, fsoExecute];
end;

function TVfsFileSource.GetProperties: TFileSourceProperties;
begin
  Result := [fspVirtual];
end;

function TVfsFileSource.GetWfxModuleList: TWFXModuleList;
begin
  Result := FWFXModuleList;
end;

function TVfsFileSource.CreateListOperation(TargetPath: String): TFileSourceOperation;
var
  TargetFileSource: IFileSource;
begin
  TargetFileSource := Self;
  Result := TVfsListOperation.Create(TargetFileSource, TargetPath);
end;

function TVfsFileSource.CreateExecuteOperation(var ExecutableFile: TFile; BasePath, Verb: String): TFileSourceOperation;
var
  TargetFileSource: IFileSource;
begin
  TargetFileSource := Self;
  Result:=  TVfsExecuteOperation.Create(TargetFileSource, ExecutableFile, BasePath, Verb);
end;

end.

