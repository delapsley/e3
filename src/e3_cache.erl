%%----------------------------------------------------------------------------
%% @author Dave Lapsley <delapsley@gmail.com>
%% @copyright 2013 Dave Lapsley.
%% @doc Caching layer.
%%
%%----------------------------------------------------------------------------
-module(e3_cache).
 
-compile([export_all]).

-include("e3.hrl"). 
 

set(Key, Value, Connection) ->
    memcached:set(Connection, Key, {ok, Value}).

set(Key, Value) ->
    set(Key, Value, ?DEFAULT_CONNECTION).

get(Key, Connection) ->
    memcached:get(Connection, Key).

get(Key) ->
    get(Key, ?DEFAULT_CONNECTION).

key_exists(Key, Connection) ->
    FetchList = memcached:get(Connection, Key),
    FetchListLength = length(FetchList),
    if
        FetchListLength > 0 -> true;
        true -> false
    end.

key_exists(Key) ->
    key_exists(Key, ?DEFAULT_CONNECTION).
    
