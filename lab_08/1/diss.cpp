template <typename Type>
Type sum(Type a, Type b)
{
    Type result;
    
    result = a + b;

    return result;
}

template <typename Type>
Type mul(Type a, Type b)
{
    Type result;

    result = a * b;

    return result;
}

int main()
{
    float f1 = 3.7f;
    float f2 = 2.3f;
    sum(f1, f2);
    mul(f1, f2);

    double d1 = 3.7;
    double d2 = 2.3;
    sum(d1, d2);
    mul(d1, d2);
}