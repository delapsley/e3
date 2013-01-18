-module(e3_file).
 
-compile([export_all]).
 
-include_lib("webmachine/include/webmachine.hrl").
 
init(Config) ->
    {{trace, "traces"}, Config}.

content_types_provided(RD, Ctx) ->
    {[ {"text/html", to_html}, {"application/json", to_json} ], RD, Ctx}.

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

to_html(RD, Ctx) ->
    Id = wrq:path_info(id, RD),
    Resp = "<html><body>" ++ Id ++ "</body></html>",
    {Resp, RD, Ctx}.

to_json(RD, Ctx) ->
    {true, RD, Ctx}.

from_text(RD, Ctx) ->
    Body = wrq:req_body(RD),
    io:format("body: ~p~n", [Body]),
    Resp_body = "cool",
    Resp = wrq:set_resp_body(Resp_body, RD),
    {true, Resp, Ctx}.

