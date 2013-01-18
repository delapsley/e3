%%----------------------------------------------------------------------------
%% @author Dave Lapsley <delapsley@gmail.com>
%% @copyright 2013 Dave Lapsley.
%% @doc Function handlers for file resource.
%%
%% This file is divided into the following sections:
%%  - Initialization
%%  - Supported Operations
%%  - Utility Functions
%%  - Incoming Operations
%%  - Outgoing Operations
%%
%%----------------------------------------------------------------------------
-module(e3_file).
 
-compile([export_all]).

-include("e3.hrl"). 
-include_lib("webmachine/include/webmachine.hrl").
 
%%----------------------------------------------------------------------------
% Initialization
%%----------------------------------------------------------------------------
init(Config) ->
    {{trace, "traces"}, Config}.


%%----------------------------------------------------------------------------
% Supported operations.
%%----------------------------------------------------------------------------
allowed_methods(RD, Ctx) ->
    {['GET', 'HEAD', 'PUT'], RD, Ctx}.

%%----------------------------------------------------------------------------
% Utility methods.
%%----------------------------------------------------------------------------
create_file_name(Id) ->
    ?FILE_DIR ++ "/" ++ Id ++ ".dat".

resource_exists(RD, Ctx) ->
    Id = wrq:path_info(id, RD),
    FileName = create_file_name(Id),
    case file:read_file_info(FileName) of
        {ok, _} ->
            {true, RD, Ctx};
        {error, _} ->
            {false, RD, Ctx}
    end.

%%----------------------------------------------------------------------------
% Incoming data operations.
%%----------------------------------------------------------------------------
content_types_provided(RD, Ctx) ->
    {[ {"text/plain", to_text} ], RD, Ctx}.

from_text(RD, Ctx) ->
    Id = wrq:path_info(id, RD),
    Resp = "<html><body>" ++ Id ++ "</body></html>",
    Expires = case wrq:get_qs_value("expires", RD) of
        'undefined' -> ?DEFAULT_EXPIRY;
        Value ->
            {IntegerValue, _} = string:to_integer(Value),
            IntegerValue
    end,
    io:format("expires: ~p~n", [Expires]),
    Body = wrq:req_body(RD),
    ok = file:write_file(create_file_name(Id), Body),
    {Resp, RD, Ctx}.

%%----------------------------------------------------------------------------
% Outdoing data operations.
%%----------------------------------------------------------------------------
content_types_accepted(RD, Ctx) ->
    { [ {"text/plain", from_text} ], RD, Ctx }.
 
to_text(RD, Ctx) ->
    Id = wrq:path_info(id, RD),
    FileName = create_file_name(Id),
    {ok, Data} = file:read_file(FileName),
    {Data, RD, Ctx}.


