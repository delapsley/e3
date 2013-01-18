%%----------------------------------------------------------------------------
%% @author Dave Lapsley <delapsley@gmail.com>
%% @copyright 2013 Dave Lapsley.
%% @doc Caching layer.
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
    KeyExists = e3_cache:key_exists(FileName),
    {KeyExists, RD, Ctx}.

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
    FileName = create_file_name(Id),
    ok = file:write_file(FileName, Body),
    e3_cache:set(FileName, {Body}),
    io:format("mc: set ~p~n", [Body]),
    {Resp, RD, Ctx}.

%%----------------------------------------------------------------------------
% Outdoing data operations.
%%----------------------------------------------------------------------------
content_types_accepted(RD, Ctx) ->
    { [ {"text/plain", from_text} ], RD, Ctx }.
 
to_text(RD, Ctx) ->
    Id = wrq:path_info(id, RD),
    FileName = create_file_name(Id),
    {ok, {Data}} = lists:nth(1, e3_cache:get(FileName)),
    io:format("mc: get ~p~n", [Data]),
    {Data, RD, Ctx}.

