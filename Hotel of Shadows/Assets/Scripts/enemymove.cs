using System.Collections;

using System.Collections.Generic;

using UnityEngine;

using UnityEngine.AI;



public class enemymove : MonoBehaviour

{

    private Transform Player;

    public Animation ghostIdle;

    private NavMeshAgent agent;

    public float MoveSpeed;
    public float MaxDist = 0.7f;
    public float MinDist = 0;
    public float enemyDistance = 0.7f;



    private void Start()

    {

        Player = GameObject.FindWithTag("Player").transform;



        //agent = GetComponent<NavMeshAgent>();

    }



    //Call every frame

    void Update()

    {

        //Look at the player

        transform.LookAt(Player);
        if (Vector3.Distance(transform.position, Player.position) >= MinDist)
        {

            transform.position += transform.forward * MoveSpeed * Time.deltaTime;

            ghostIdle.Play();
            if (Vector3.Distance(transform.position, Player.position) <= MaxDist)
            {
                Destroy(this.gameObject);

            }
        }
    }
}

