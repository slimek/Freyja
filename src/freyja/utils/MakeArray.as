package freyja.utils 
{
    /**
     * 建立一個指定大小的 Array，裡面填入相同的預設值。
     * @param	size
     * @param	defaultValue
     */
    public function MakeArray( size: uint, fillValue: Object ) : Array
    {
        var result: Array = new Array;
        for ( var i: int = 0; i < size; ++ i )
        {
            result.push( fillValue );
        }
        return result;
    }

}