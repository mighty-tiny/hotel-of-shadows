using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class Dialogue : MonoBehaviour
{
    public TextMeshProUGUI textcomponent;
    //public GameObject[] things;
    //public bool gathered;
    public string[] lines;
    public float speed;
    private int index;
    // Start is called before the first frame update
    void Start()
    {
        textcomponent.text = string.Empty;
        StartDialogue();
    }
    private void Update()
    {
        //if (!things[0].activeInHierarchy && !things[1].activeInHierarchy && !things[2].activeInHierarchy)
        //{
        //    gathered = true;
        //}
        //if (gathered)
        //{
        //    textcomponent.text = " ";
        //    gathered = false;
        //}

        if (Input.GetMouseButtonDown(0))
        {
            if (textcomponent.text == lines[index])
            {
                NextLine();
            }
            else
            {
                StopAllCoroutines();
                textcomponent.text = lines[index];
            }
        }
    }
    void StartDialogue()
    {
        index = 0;
        StartCoroutine(TypeLine());
    }
    IEnumerator TypeLine()
    {
        foreach (char c in lines[index].ToCharArray())
        {
            textcomponent.text += c;
            yield return new WaitForSeconds(speed);
        }
    }
    void NextLine()
    {
        if (index < lines.Length - 1)
        {
            index++;
            textcomponent.text = string.Empty;
            StartCoroutine(TypeLine());
        }
        else
        {
            gameObject.SetActive(false);
        }
    }
}
