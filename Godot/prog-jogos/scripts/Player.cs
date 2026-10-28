using Godot;

public partial class Player : CharacterBody2D
{
    private const float Speed = 200.0f;

    public override void _Ready()
    {
        GD.Print("Player inicializado - normalização manual");
    }

    public override void _PhysicsProcess(double delta)
    {
        float directionX = 0.0f;
        float directionY = 0.0f;

        // Movimentações horizontais e verticais
        if (Input.IsActionPressed("move_right")) directionX += 1.0f;
        if (Input.IsActionPressed("move_left")) directionX -= 1.0f;
        if (Input.IsActionPressed("move_down")) directionY += 1.0f;
        if (Input.IsActionPressed("move_up")) directionY -= 1.0f;

        Vector2 direction = new Vector2(directionX, directionY);

        if (direction != Vector2.Zero)
        {
            direction = direction.Normalized();
        }

        Velocity = direction * Speed;
        MoveAndSlide();
    }
}