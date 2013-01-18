%% @author Dave Lapsley <delapsley@gmail.com>
%% @copyright 2013 author.

%% @doc Callbacks for the e3 application.

-module(e3_app).
-author('Dave Lapsley <delapsley@gmail.com>').

-behaviour(application).
-export([start/2,stop/1]).


%% @spec start(_Type, _StartArgs) -> ServerRet
%% @doc application start callback for e3.
start(_Type, _StartArgs) ->
    e3_sup:start_link().

%% @spec stop(_State) -> ServerRet
%% @doc application stop callback for e3.
stop(_State) ->
    ok.
