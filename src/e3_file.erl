-module(e3_file).
 
-compile([export_all]).
 
-include_lib("webmachine/include/webmachine.hrl").
 
init(Config) ->
    %% fill the database with some test data
    %% prp_schema:init_tables(),
    %% prp_schema:fill_with_dummies(),
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
    %Id = wrq:path_info(id, RD),
    % {paper, Id2, Title} = prp_schema:read_paper(Id),
    %Resp = mochijson:encode({struct, [
    %            {id, integer_to_list(Id2)},
    %            {title, Title}
    %]}),
    {true, RD, Ctx}.

from_json(RD, Ctx) ->
    Id = wrq:path_info(id, RD),
    <<"title=", Title/binary>> = wrq:req_body(RD),
    Title1 = binary_to_list(Title),
    % prp_schema:create_paper(list_to_integer(Id), Title1),
    %JSON = list_to_binary(paper2json(Id, Title)),
    JSON = "{\"id\":\"0\",\"title\":\"ABC\"}",
    Resp = wrq:set_resp_body(JSON, RD),
    {true, Resp, Ctx}.
 
from_text(RD, Ctx) ->
    Body = wrq:req_body(RD),
    io:format("body: ~p~n", [Body]),
    Resp_body = "cool",
    Resp = wrq:set_resp_body(Resp_body, RD),
    {true, Resp, Ctx}.

