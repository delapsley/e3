-module(e3_file).
 
-compile([export_all]).

-include("e3.hrl"). 
-include_lib("webmachine/include/webmachine.hrl").
 
init(Config) ->
    {{trace, "traces"}, Config}.

content_types_provided(RD, Ctx) ->
    {[ {"text/plain", to_text} ], RD, Ctx}.

content_types_accepted(RD, Ctx) ->
    { [ {"text/plain", from_text} ], RD, Ctx }.
 
allowed_methods(RD, Ctx) ->
    {['GET', 'HEAD', 'PUT'], RD, Ctx}.

resource_exists(RD, Ctx) ->
    {Id, _} = string:to_integer(wrq:path_info(id, RD)),
    io:format("id: ~p~n", [Id]),
    if
        Id =< 3 ->
            io:format("true~n", []),
            {true, RD, Ctx};
        true ->
            io:format("false~n", []),
            {false, RD, Ctx}
    end.

create_file_name(Id) ->
    ?FILE_DIR ++ "/" ++ Id ++ ".dat".

from_text(RD, Ctx) ->
    Id = wrq:path_info(id, RD),
    Resp = "<html><body>" ++ Id ++ "</body></html>",
    Body = wrq:req_body(RD),
    ok = file:write_file(create_file_name(Id), Body),
    {Resp, RD, Ctx}.

to_text(RD, Ctx) ->
    Id = wrq:path_info(id, RD),
    {ok, Data} = file:read_file(create_file_name(Id)),
    {Data, RD, Ctx}.


