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
    Id = wrq:path_info(id, RD),
    FileName = create_file_name(Id),
    io:format("FileName: ~p~n", [FileName]),
    case file:read_file_info(FileName) of
        {ok, _} ->
            {true, RD, Ctx};
        {error, _} ->
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


